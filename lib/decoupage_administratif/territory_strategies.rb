# frozen_string_literal: true

module DecoupageAdministratif
  module TerritoryStrategies
    class Base
      def initialize(territory)
        @territory = territory
      end

      def includes_any_commune_code?(commune_insee_codes)
        return false if commune_insee_codes.empty?

        check_inclusion(commune_insee_codes)
      end

      def insee_codes
        @insee_codes ||= calculate_insee_codes
      end

      private

      attr_reader :territory

      def check_inclusion(commune_insee_codes)
        raise NotImplementedError, "Must be implemented by subclass"
      end

      def calculate_insee_codes
        raise NotImplementedError, "Must be implemented by subclass"
      end
    end

    class CommuneStrategy < Base
      private

      def check_inclusion(commune_insee_codes)
        commune_insee_codes.include?(territory.code)
      end

      def calculate_insee_codes
        [territory.code]
      end
    end

    class DepartementStrategy < Base
      private

      def check_inclusion(commune_insee_codes)
        departement_prefix = territory.code.length == 2 ? territory.code : territory.code[0..1]
        commune_insee_codes.any? { |commune_code| commune_code.start_with?(departement_prefix) }
      end

      def calculate_insee_codes
        territory.communes.map(&:code)
      end
    end

    class RegionStrategy < Base
      private

      def check_inclusion(commune_insee_codes)
        departement_codes = territory.departements.map(&:code)
        commune_insee_codes.any? do |commune_code|
          dept_code = commune_code.length >= 3 && commune_code[0..1].to_i >= 96 ? commune_code[0..2] : commune_code[0..1]
          departement_codes.include?(dept_code)
        end
      end

      def calculate_insee_codes
        territory.communes.map(&:code)
      end
    end

    class EpciStrategy < Base
      private

      def check_inclusion(commune_insee_codes)
        epci_commune_codes = territory.membres.map { |membre| membre[:code] || membre["code"] }
        (epci_commune_codes & commune_insee_codes).any?
      end

      def calculate_insee_codes
        territory.membres.map { |membre| membre[:code] || membre["code"] }
      end
    end
  end
end
