# frozen_string_literal: true

module DecoupageAdministratif
  module BaseModel
    # Find a single record by its code (primary key equivalent)
    # @param code [String] the code to search for
    # @return [Object, nil] the element with the given code, or nil if not found
    # @raise [NotFoundError] if the record is not found and no default block is given
    # @example
    #   DecoupageAdministratif::Commune.find('72039')
    #   DecoupageAdministratif::Region.find('52')
    def find(code)
      result = find_by(code: code)
      if result.nil?
        raise DecoupageAdministratif::NotFoundError.new(
          "#{name.split('::').last} not found for code #{code}",
          code: code
        )
      end

      result
    end

    # @param criteria [Hash] a hash with the attributes to filter by
    # @return [untyped] the element that matches the criteria
    # @example
    #   DecoupageAdministratif::Commune.find_by(nom: 'Paris')
    def find_by(criteria)
      all.find { |item| criteria.all? { |k, v| item.send(k) == v } }
    end

    # Filter records based on criteria with optional case-insensitive and partial matching
    #
    # @param args [Hash] keyword arguments containing filter criteria and options
    # @option args [Boolean] :case_insensitive perform case-insensitive matching (only for String values)
    # @option args [Boolean] :partial allow partial string matching using contains logic (only for String values)
    #
    # @note When filtering with an Array:
    #   - Without options: checks if the item's value is included in the array (similar to SQL IN clause)
    #   - With case_insensitive: performs case-insensitive matching for each array element (String values only)
    #   - With partial: checks if item's value contains any of the array elements (String values only)
    #   - Both options can be combined for case-insensitive partial matching
    #
    # @return [Array] an array of all items that match the criteria
    #
    # @example Simple filtering
    #   DecoupageAdministratif::Departement.where(code_region: '52')
    #
    # @example Case-insensitive and partial matching
    #   DecoupageAdministratif::Commune.where(nom: 'pari', case_insensitive: true, partial: true)
    #
    # @example Array filtering (SQL IN-like behavior)
    #   DecoupageAdministratif::Commune.where(commune_type: [:commune_actuelle, :arrondissement_municipal])
    #
    # @example Array filtering with case-insensitive matching
    #   DecoupageAdministratif::Commune.where(nom: ['paris', 'mamers'], case_insensitive: true)
    #
    # @example Array filtering with partial matching
    #   DecoupageAdministratif::Commune.where(nom: ['par', 'mam'], partial: true)
    def where(**args)
      case_insensitive = args.delete(:case_insensitive) || false
      partial = args.delete(:partial) || false

      all.select do |item|
        args.all? { |key, value| matches?(item.send(key), value, case_insensitive, partial) }
      end
    end

    private

    # Check if item_value matches the filter_value based on options
    #
    # @param item_value [Object] the value from the item being filtered
    # @param filter_value [Object, Array] the value(s) to filter by
    # @param case_insensitive [Boolean] whether to perform case-insensitive matching
    # @param partial [Boolean] whether to perform partial (contains) matching
    # @return [Boolean] true if the value matches the filter
    def matches?(item_value, filter_value, case_insensitive, partial)
      return match_item_array?(item_value, filter_value, case_insensitive, partial) if item_value.is_a?(Array)
      return match_array?(item_value, filter_value, case_insensitive, partial) if filter_value.is_a?(Array)
      return match_single_value?(item_value, filter_value, case_insensitive, partial) if strings?(item_value, filter_value)

      item_value == filter_value
    end

    # Check if any element of the item array matches the filter values
    #
    # @param item_array [Array] the array value from the item being filtered
    # @param filter_values [Array] the array of values to filter by
    # @param case_insensitive [Boolean] whether to perform case-insensitive matching
    # @param partial [Boolean] whether to perform partial (contains) matching
    # @return [Boolean] true if any element of the item array matches any filter value
    def match_item_array?(item_array, filter_values, case_insensitive, partial)
      return false unless filter_values.is_a?(Array)

      item_array.any? do |element|
        filter_values.any? { |fv| matches?(element, fv, case_insensitive, partial) }
      end
    end

    # Check if item_value matches any value in the filter array
    #
    # @param item_value [Object] the value from the item being filtered
    # @param filter_array [Array] array of values to match against
    # @param case_insensitive [Boolean] whether to perform case-insensitive matching
    # @param partial [Boolean] whether to perform partial (contains) matching
    # @return [Boolean] true if the value matches any element in the array
    def match_array?(item_value, filter_array, case_insensitive, partial)
      return filter_array.include?(item_value) unless apply_string_options?(item_value, filter_array)

      filter_array.any? { |filter_element| match_single_value?(item_value, filter_element, case_insensitive, partial) }
    end

    # Check if item_value matches filter_value with string options
    #
    # @param item_value [String] the string value from the item
    # @param filter_value [String] the string value to filter by
    # @param case_insensitive [Boolean] whether to perform case-insensitive matching
    # @param partial [Boolean] whether to use partial (contains) matching
    # @return [Boolean] true if strings match according to options
    def match_single_value?(item_value, filter_value, case_insensitive, partial)
      return item_value.downcase.include?(filter_value.downcase) if case_insensitive && partial
      return item_value.downcase == filter_value.downcase if case_insensitive
      return item_value.include?(filter_value) if partial

      item_value == filter_value
    end

    # Check if both values are strings
    #
    # @param value1 [Object] first value to check
    # @param value2 [Object] second value to check
    # @return [Boolean] true if both values are strings
    def strings?(value1, value2)
      value1.is_a?(String) && value2.is_a?(String)
    end

    # Check if string matching options should be applied
    #
    # @param item_value [Object] the value from the item
    # @param filter_array [Array] the filter array
    # @return [Boolean] true if string options should be applied
    def apply_string_options?(item_value, filter_array)
      item_value.is_a?(String) && filter_array.all? { |v| v.is_a?(String) }
    end
  end
end
