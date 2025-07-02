# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    extend BaseModel

    # @!attribute [r] code
    #   @return [String] INSEE code of the commune
    # @!attribute [r] nom
    #   @return [String] Name of the commune
    # @!attribute [r] zone
    #   @return [String] Zone of the commune ("metro", "drom", "com")
    # @!attribute [r] region_code
    #   @return [String] INSEE code of the region
    # @!attribute [r] departement_code
    #   @return [String] INSEE code of the department
    # @!attribute [r] commune_type
    #   @return [String] Type of the commune (default: "commune-actuelle")
    attr_reader :code, :nom, :zone, :region_code, :departement_code, :commune_type

    # rubocop:disable Metrics/ParameterLists
    # @param code [String] the INSEE code of the commune
    # @param nom [String] the name of the commune
    # @param zone [String] the zone of the commune ("metro", "drom", "com")
    # @param region_code [String] the INSEE code of the region
    # @param departement_code [String] the INSEE code of the department
    # @param commune_type [String] the type of the commune (default: "commune-actuelle")
    def initialize(code:, nom:, zone:, region_code:, departement_code:, commune_type: "commune-actuelle")
      @code = code
      @nom = nom
      @zone = zone
      @region_code = region_code
      @departement_code = departement_code
      @commune_type = commune_type
    end
    # rubocop:enable Metrics/ParameterLists

    # @return [Array<Commune>] a collection of all communes
    def self.all
      @all ||= Parser.new('communes').data.map do |commune_data|
        Commune.new(
          code: commune_data["code"],
          nom: commune_data["nom"],
          zone: commune_data["zone"],
          region_code: commune_data["region"],
          departement_code: commune_data["departement"],
          commune_type: commune_data["type"]
        )
      end
    end

    # @return [Array<Commune>] a collection of all actual communes
    def self.communes_actuelles
      @communes_actuelles ||= all.select { |commune| commune.commune_type == "commune-actuelle" }
    end

    # @raise [TypeError] if no department is found for the code
    # @return [Departement] the department of the commune
    def departement
      departement = DecoupageAdministratif::Departement.find_by(code: @departement_code)
      raise TypeError, "No department found for code #{@departement_code}" unless departement.is_a?(DecoupageAdministratif::Departement)

      @departement ||= departement
    end

    # @return [Epci, nil] the EPCI of the commune, if it belongs to one
    def epci
      found_epci = DecoupageAdministratif::Epci.all.find do |epci|
        epci.membres.any? { |m| m["code"] == @code }
      end
      found_epci.is_a?(DecoupageAdministratif::Epci) ? (@epci ||= found_epci) : nil
    end

    # @raise [TypeError] if no region is found for the code
    # @return [Region] the region of the commune
    def region
      region = DecoupageAdministratif::Region.find_by(code: @region_code)
      raise TypeError, "Aucune région trouvée pour le code #{@region_code}" unless region.is_a?(DecoupageAdministratif::Region)

      @region ||= region
    end
  end
end
