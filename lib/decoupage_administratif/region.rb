# frozen_string_literal: true

module DecoupageAdministratif
  class Region
    extend BaseModel
    attr_reader :code, :nom, :zone, :region

    # @param code [String] the INSEE code of the region
    # @param nom [String] the name of the region
    # @param zone [String] the zone of the region ("metro", "drom", "com")
    def initialize(code:, nom:, zone:)
      @code = code
      @nom = nom
      @zone = zone
    end

    # @return [RegionCollection] a collection of all regions
    def self.all
      @all ||= RegionCollection.new(Parser.new('regions').data.map do |region_data|
        Region.new(
          code: region_data["code"],
          nom: region_data["nom"],
          zone: region_data["zone"]
        )
      end)
    end

    # @return [DepartementCollection] a collection of all departments in the region
    def departements
      @departements ||= DecoupageAdministratif::Departement.all.select do |departement|
        departement.code_region == @code
      end
    end

    # @return [CommuneCollection] a collection of all actual communes in the region
    def communes
      @communes ||= DecoupageAdministratif::Commune.all.select do |commune|
        commune.region_code == @code && commune.commune_type == "commune-actuelle"
      end
    end
  end

  class RegionCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
