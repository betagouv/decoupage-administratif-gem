# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    attr_reader :code, :nom, :zone, :region_code, :departement_code, :commune_type

    def initialize(code:, nom:, zone:, region_code:, departement_code:, commune_type: "commune-actuelle")
      @code = code
      @nom = nom
      @zone = zone
      @region_code = region_code
      @departement_code = departement_code
      @commune_type = commune_type
    end

    class << self
      def all
        @all ||= CommuneCollection.new(Parser.new('communes').data.map do |commune_data|
          Commune.new(
            code: commune_data["code"],
            nom: commune_data["nom"],
            zone: commune_data["zone"],
            region_code: commune_data["region"],
            departement_code: commune_data["departement"],
            commune_type: commune_data["type"]
          )
        end)
      end

      def communes_actuelles
        @communes_actuelles ||= communes.select { |commune| commune.commune_type == "commune-actuelle" }
      end

      def communes
        @communes ||= all
      end
    end

    def departement
      @departement ||= DecoupageAdministratif::Departement.find_by(code: @departement_code)
    end

    def epci
      @epci ||= DecoupageAdministratif::Epci.all.find { |epci| epci.membres.map { |m| m["code"] }.include?(@code) }
    end

    def region
      @region ||= DecoupageAdministratif::Region.find_by(code: @region_code)
    end
  end

  class CommuneCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
