# frozen_string_literal: true

module DecoupageAdministratif
  class Departement
    extend BaseModel
    include TerritoryExtensions

    # @!attribute [r] code
    #   @return [String] INSEE code of the department
    # @!attribute [r] nom
    #   @return [String] Name of the department
    # @!attribute [r] zone
    #   @return [String] Zone of the department ("metro", "drom", "com")
    # @!attribute [r] code_region
    #   @return [String] INSEE code of the region
    attr_reader :code, :nom, :zone, :code_region

    # @param code [String] the INSEE code of the department
    # @param nom [String] the name of the department
    # @param zone [String] the zone of the department ("metro", "drom", "com")
    # @param code_region [String] the INSEE code of the region
    def initialize(code:, nom:, zone:, code_region:)
      @code = code
      @nom = nom
      @zone = zone
      @code_region = code_region
    end

    # @return [Array<Departement>] a collection of all departments
    def self.all
      @all ||= Parser.new('departements').data.map do |departement_data|
        DecoupageAdministratif::Departement.new(
          code: departement_data["code"],
          nom: departement_data["nom"],
          zone: departement_data["zone"],
          code_region: departement_data["region"]
        )
      end
    end

    # @return [Array<Commune>] a collection of all actual communes in the department
    def communes
      @communes ||= DecoupageAdministratif::Commune.where(departement_code: @code, commune_type: :commune_actuelle)
    end

    # @raise [NotFoundError] if no region is found for the code
    # @return [Region] the region of the department
    def region
      @region ||= DecoupageAdministratif::Region.find(@code_region)
    end
  end
end
