# frozen_string_literal: true

module DecoupageAdministratif
  class Departement
    attr_reader :code, :nom, :zone, :code_region

    def initialize(code:, nom:, zone:, code_region:)
      @code = code
      @nom = nom
      @zone = zone
      @code_region = code_region
    end

    class << self
      def all
        Parser.new('departements').data.map do |departement_data|
          DecoupageAdministratif::Departement.new(
            code: departement_data["code"],
            nom: departement_data["nom"],
            zone: departement_data["zone"],
            code_region: departement_data["region"]
          )
        end
      end

      def departements
        @departements ||= all
      end

      def find_by_code(code)
        departements.find { |departement| departement.code == code }
      end
    end
  end
end
