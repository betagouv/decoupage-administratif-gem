# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    attr_reader :code, :nom, :zone, :region, :departement_code

    def initialize(code:, nom:, zone:, region:, departement_code:)
      @code = code
      @nom = nom
      @zone = zone
      @region = region
      @departement_code = departement_code
    end

    class << self
      def all
        Parser.new('communes').data.map do |commune_data|
          Commune.new(
            code: commune_data["code"],
            nom: commune_data["nom"],
            zone: commune_data["zone"],
            region: commune_data["region"],
            departement_code: commune_data["departement"]
          )
        end
      end

      def communes
        @communes ||= all
      end

      def find_by_code(code)
        communes.find { |commune| commune.code == code }
      end
    end

    def departement
      DecoupageAdministratif::Departement.find_by_code(@departement_code)
    end
  end
end
