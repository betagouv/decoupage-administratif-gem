# frozen_string_literal: true

module DecoupageAdministratif
  class Search
    # @!attribute [r] codes
    #   @return [Array<String>, nil] List of INSEE codes used for the search
    # @!attribute [r] regions
    #   @return [Array<Region>] Regions found by the search
    # @!attribute [r] departements
    #   @return [Array<Departement>] Departments found by the search
    # @!attribute [r] epcis
    #   @return [Array<Epci>] EPCIs found by the search
    # @!attribute [r] communes
    #   @return [Array<Commune>] Communes found by the search
    attr_reader :codes, :regions, :departements, :epcis, :communes

    def initialize(codes = nil)
      @codes = codes&.uniq
      initialize_class_caches
    end

    # Search for territories by municipality.
    # If the list of municipalities represents a department or an EPCI, the corresponding territories are displayed.
    # If the codes do not correspond to any territory, a list of municipalities is returned.
    # @return [Hash] a hash containing the regions, departments, EPCI, and communes found
    # @note Returns empty arrays if no territories are found for the given codes.
    def by_insee_codes
      @codes = group_by_departement
      @codes = find_communes_by_codes

      search_for_departements
      search_for_region
      search_for_epcis
      search_for_communes

      {
        regions: @regions,
        departements: @departements,
        epcis: @epcis,
        communes: @communes
      }
    end

    # Return the territories associated with a given INSEE code.
    # @param code_insee [String] the INSEE code of the commune
    # @return [Hash] a hash containing the EPCI, department, and region associated with the commune
    def find_territories_by_commune_insee_code(code_insee)
      # Use cache if available, fallback to find_by for compatibility with tests
      commune = @@communes_cache&.[](code_insee) || DecoupageAdministratif::Commune.find_by(code: code_insee)
      return {} if commune.nil?

      {
        epci: commune.epci,
        departement: commune.departement,
        region: commune.region
      }
    end

    private

    # Class-level caches for performance optimization
    # rubocop:disable Style/ClassVars
    @@departements_cache = nil
    @@communes_cache = nil
    # rubocop:enable Style/ClassVars

    # Initialize class-level caches for performance optimization
    # @return [void]
    def initialize_class_caches
      return if @@departements_cache && @@communes_cache

      # rubocop:disable Style/ClassVars
      @@departements_cache = DecoupageAdministratif::Departement.all.each_with_object({}) { |dept, hash| hash[dept.code] = dept }
      @@communes_cache = DecoupageAdministratif::Commune.actuelles.each_with_object({}) { |commune, hash| hash[commune.code] = commune }
      # rubocop:enable Style/ClassVars
    end

    # Group the codes by department.
    # @return [Hash<Departement, Array<Commune>>] Hash with departments as keys and their communes as values
    def group_by_departement
      # Group the codes by DecoupageAdministratif::Departement
      # and DecoupageAdministratif::Communes as values
      @codes.group_by do |code|
        dept_code = code[0..1] == "97" ? code[0..2] : code[0..1]
        @@departements_cache[dept_code]
      end
    end

    # Find communes by their codes.
    # @return [Array<Commune>] List of communes matching the codes
    def find_communes_by_codes
      @codes.transform_values do |codes_insee|
        codes_insee.filter_map do |code|
          commune = @@communes_cache[code]
          next if commune.nil?

          commune.commune_type == :commune_actuelle ? commune : nil
        end
      end
    end

    # Search for departments matching the codes.
    # @return [void]
    def search_for_departements
      @departements = []
      return if only_nil_key?

      departements_to_delete = []
      @codes.each do |departement, communes|
        next unless should_add_departement?(departement, communes)

        @departements << departement
        departements_to_delete << departement
      end
      departements_to_delete.each { |dep_code| @codes.delete(dep_code) }
    end

    # Check if only one key and it is nil
    # @return [Boolean]
    def only_nil_key?
      @codes.keys.uniq.one? && @codes.keys.first.nil?
    end

    # Should add departement to result?
    # @param departement [Departement, nil]
    # @param communes [Array<Commune>]
    # @return [Boolean]
    def should_add_departement?(departement, communes)
      return false if departement.nil?

      departement.communes.count == communes.count && departement.communes.map(&:code).sort == communes.map(&:code).sort
    end

    # Search for regions matching the codes.
    # @return [void]
    def search_for_region
      @regions = []
      return if @departements.empty?

      regions = DecoupageAdministratif::Region.all
      regions.each do |region|
        next unless region.departements.all? do |departement|
          @departements.map(&:code).include? departement.code
        end

        @regions << region
        region.departements.each do |departement|
          @departements.delete(departement)
        end
      end
    end

    # Search for EPCIs matching the codes.
    # @return [void]
    def search_for_epcis
      @epcis = []
      return if @codes.keys.uniq.one? && @codes.keys.first.nil?

      @codes.each_value do |communes|
        # Find EPCIs that match all communes in the current group
        @epcis = DecoupageAdministratif::Epci.search_by_communes_codes(communes.map(&:code))
        @epcis.each do |epci|
          communes.reject! do |commune|
            epci.communes.include?(commune)
          end
        end
      end
    end

    # Search for communes matching the codes.
    # @return [void]
    def search_for_communes
      @communes = []
      return if @codes.keys.uniq.one? && @codes.keys.first.nil?

      @codes.each_value do |communes|
        communes.map { |commune| @communes << commune }
      end
    end
  end
end
