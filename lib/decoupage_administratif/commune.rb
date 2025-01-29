# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    attr_reader :code, :nom, :zone, :region, :departement_code, :commune_type

    def initialize(code:, nom:, zone:, region:, departement_code:, commune_type:)
      @code = code
      @nom = nom
      @zone = zone
      @region = region
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
            region: commune_data["region"],
            departement_code: commune_data["departement"],
            commune_type: commune_data["type"]
          )
        end)
      end

      def communes
        @communes ||= all
      end

      def find_by_code(code)
        communes.find { |commune| commune.code == code }
      end
    end

    def departement
      @departement ||= DecoupageAdministratif::Departement.find_by_code(@departement_code)
    end
  end

  class CommuneCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
