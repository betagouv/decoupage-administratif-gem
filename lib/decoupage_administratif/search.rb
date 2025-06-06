# frozen_string_literal: true

module DecoupageAdministratif
  class Search
    def initialize(codes)
      @codes = codes.uniq
    end

    # Search for territories by municipality.
    # If the list of municipalities represents a department or an EPCI, the corresponding territories are displayed.
    # If the codes do not correspond to any territory, a list of municipalities is returned.
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

    private

    def search_for_departements
      @departements = []
      @codes.each do |departement, communes|
        # if the departement has the same number of communes as the codes and all communes code are in code_insee we return the departement
        next unless departement.communes.count == communes.count && departement.communes.map(&:code).sort == communes.map(&:code).sort

        @departements << departement
        # delete the depaertement from the hash
        @codes.delete(departement)
      end
    end

    def search_for_region
      @regions = []
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

    def search_for_epcis
      @epcis = []
      @codes.each_value do |communes|
        # if the departement has the same number of communes as the codes and all communes code are in code_insee we return the departement
        @epcis = DecoupageAdministratif::Epci.find_by_communes_codes(communes.map(&:code))
        @epcis.each do |epci|
          communes.reject! do |commune|
            epci.communes.include?(commune)
          end
        end
      end
    end

    def search_for_communes
      @communes = []
      @codes.each_value do |communes|
        communes.map { |commune| @communes << commune }
      end
    end

    def group_by_departement
      # group the codes by DecoupageAdministratif::Departement
      # and DecoupageAdministratif::Communes as values
      @codes.group_by do |code|
        code = if code[0..1] == "97"
                 code[0..2]
               else
                 code[0..1]
               end
        DecoupageAdministratif::Departement.find_by(code: code)
      end
    end

    def find_communes_by_codes
      @codes.transform_values do |codes_insee|
        codes_insee.map do |code|
          commune = DecoupageAdministratif::Commune.find_by(code: code)
          next if commune.nil?

          commune.commune_type == "commune-actuelle" ? commune : nil
        end.compact
      end
    end
  end
end
