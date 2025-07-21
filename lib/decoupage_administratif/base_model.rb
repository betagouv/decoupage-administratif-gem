# frozen_string_literal: true

module DecoupageAdministratif
  module BaseModel
    # @param criteria [Hash] a hash with the attributes to filter by
    # @return [untyped] the element that matches the criteria
    # @example
    #   DecoupageAdministratif::Commune.find_by(code: '72039')
    def find_by(criteria)
      all.find { |item| criteria.all? { |k, v| item.send(k) == v } }
    end

    # @param args [Hash] keyword arguments containing filter criteria and options
    # @option args [Boolean] :case_insensitive perform case-insensitive matching
    # @option args [Boolean] :partial allow partial string matching (contains)
    # @return [Array] an array of all items that match the criteria
    # @example
    #   DecoupageAdministratif::Departement.where(code_region: '52')
    #   DecoupageAdministratif::Commune.where(nom: 'pari', case_insensitive: true, partial: true)
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def where(**args)
      # Separate options from criteria
      case_insensitive = args.delete(:case_insensitive) || false
      partial = args.delete(:partial) || false

      all.select do |item|
        args.all? do |key, value|
          item_value = item.send(key)

          if case_insensitive && value.is_a?(String) && item_value.is_a?(String)
            if partial
              item_value.downcase.include?(value.downcase)
            else
              item_value.downcase == value.downcase
            end
          elsif partial && value.is_a?(String) && item_value.is_a?(String)
            item_value.include?(value)
          else
            item_value == value
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    end
  end
end
