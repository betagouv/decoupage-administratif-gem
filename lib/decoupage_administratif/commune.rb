# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    attr_reader :code, :nom, :zone, :region, :departement

    def initialize(code:, nom:, zone:, region:, departement:)
      @code = code
      @nom = nom
      @zone = zone
      @region = region
      @departement = departement
    end

    class << self
      def all
        Parser.new('communes').data.map do |commune_data|
          Commune.new(
            code: commune_data["code"],
            nom: commune_data["nom"],
            zone: commune_data["zone"],
            region: commune_data["region"],
            departement: commune_data["departement"]
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
  end
end
