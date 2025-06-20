# frozen_string_literal: true

module DecoupageAdministratif
  class Departement
    extend BaseModel
    attr_reader :code, :nom, :zone, :code_region

    def initialize(code:, nom:, zone:, code_region:)
      @code = code
      @nom = nom
      @zone = zone
      @code_region = code_region
    end

    class << self
      def all
        @all ||= DepartementCollection.new(Parser.new('departements').data.map do |departement_data|
          DecoupageAdministratif::Departement.new(
            code: departement_data["code"],
            nom: departement_data["nom"],
            zone: departement_data["zone"],
            code_region: departement_data["region"]
          )
        end)
      end

      def departements
        @departements ||= all
      end
    end

    def communes
      @communes ||= DecoupageAdministratif::Commune.all.select do |commune|
        commune.departement_code == @code && commune.commune_type == "commune-actuelle"
      end
    end

    def region
      @region ||= DecoupageAdministratif::Region.find_by(code: @code_region)
    end
  end

  class DepartementCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
