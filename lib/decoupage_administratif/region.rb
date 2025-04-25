# frozen_string_literal: true

module DecoupageAdministratif
  class Region
    attr_reader :code, :nom, :zone, :region

    def initialize(code:, nom:, zone:)
      @code = code
      @nom = nom
      @zone = zone
    end

    class << self
      def all
        @all ||= RegionCollection.new(Parser.new('regions').data.map do |region_data|
          Region.new(
            code: region_data["code"],
            nom: region_data["nom"],
            zone: region_data["zone"]
          )
        end)
      end

      def regions
        @regions ||= all
      end

      def find_by_code(code)
        regions.find { |region| region.code == code }
      end
    end

    def departements
      @departements ||= DecoupageAdministratif::Departement.all.select do |departement|
        departement.code_region == @code
      end
    end

    def communes
      @communes ||= DecoupageAdministratif::Commune.all.select do |commune|
        commune.region_code == @code
      end
    end
  end

  class RegionCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
