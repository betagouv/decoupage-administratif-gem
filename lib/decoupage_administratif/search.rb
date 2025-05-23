# frozen_string_literal: true

module DecoupageAdministratif
  class Search

    def initialize(codes)
      @codes = codes.uniq
    end

    # Search for territories by municipality.
    # If the list of municipalities represents a department or an EPCI, the corresponding territories are displayed.
    # If the codes do not correspond to any territory, a list of municipalities is returned.
    def by_insee_codes
      @codes = group_by_departement
      @codes = find_communes_by_codes

      departements = search_for_departements
      epcis = search_for_epcis
      communes = search_for_communes

      return {
        departements: departements,
        epcis: epcis,
        communes: communes
      }
    end

    private

    def search_for_departements
      departements = []
      @codes.each do |departement, communes|

        # if the departement has the same number of communes as the codes and all communes code are in code_insee we return the departement
        if departement.communes.count == communes.count && departement.communes.map(&:code).sort == communes.map(&:code).sort
          departements << departement
          # delete the depaertement from the hash
          @codes.delete(departement)
        end
      end
      departements
    end

    def search_for_epcis
      epcis = []
      @codes.each do |_, communes|
        # if the departement has the same number of communes as the codes and all communes code are in code_insee we return the departement
        epcis = DecoupageAdministratif::Epci.find_by_communes_codes(communes.map(&:code))
        epcis.each do |epci|
          communes.reject! do |commune|
            epci.communes.include?(commune)
          end
        end
      end
      epcis
    end

    def search_for_communes
      communes_collection = []
      @codes.each do |_, communes|
        communes.map { |commune| communes_collection << commune }
      end
        communes_collection
    end

    def group_by_departement
      # group the codes by DecoupageAdministratif::Departement
      # and DecoupageAdministratif::Communes as values
      @codes.group_by do |code|
        code = if code[0..1] == "97"
          code[0..2]
        else
          code[0..1]
        end
        DecoupageAdministratif::Departement.find_by_code(code)
      end
    end

    def find_communes_by_codes
      @codes.transform_values do |codes_insee|

        codes_insee.map do |code|
          commune = DecoupageAdministratif::Commune.find_by_code(code)
          next if commune.nil?
          commune.commune_type == "commune-actuelle" ? commune : nil
        end.compact
      end
    end
  end
end
