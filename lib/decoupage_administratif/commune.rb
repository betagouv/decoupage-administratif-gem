# frozen_string_literal: true

module DecoupageAdministratif
  class Commune
    extend BaseModel
    attr_reader :code, :nom, :zone, :region_code, :departement_code, :commune_type

    # rubocop:disable Metrics/ParameterLists
    def initialize(code:, nom:, zone:, region_code:, departement_code:, commune_type: "commune-actuelle")
      @code = code
      @nom = nom
      @zone = zone
      @region_code = region_code
      @departement_code = departement_code
      @commune_type = commune_type
    end
    # rubocop:enable Metrics/ParameterLists
    #
    def self.all
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

    # Returns a collection of all actual communes.
    def self.communes_actuelles
      @communes_actuelles ||= all.select { |commune| commune.commune_type == "commune-actuelle" }
    end

    # Return the department of the commune.
    def departement
      @departement ||= DecoupageAdministratif::Departement.find_by(code: @departement_code)
    end

    # Return the EPCI of the commune.
    def epci
      @epci ||= DecoupageAdministratif::Epci.all.find { |epci| epci.membres.map { |m| m["code"] }.include?(@code) }
    end

    # Return the region of the commune.
    def region
      @region ||= DecoupageAdministratif::Region.find_by(code: @region_code)
    end
  end

  class CommuneCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
