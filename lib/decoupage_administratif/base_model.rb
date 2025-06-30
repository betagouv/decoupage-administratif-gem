# frozen_string_literal: true

module DecoupageAdministratif
  module BaseModel
    # @param criteria [Hash] a hash with the attributes to filter by
    # @return [untyped] the element that matches the criteria
    # @example
    #   DecoupageAdministratif::Commune.find_by(code: '72039')
    def find_by(criteria)
      all.find { |item| item.send(criteria.keys.first) == criteria.values.first }
    end

    # @param criteria [Hash] a hash with the attributes to filter by
    # @return [Array] an array of all items that match the criteria
    # @example
    #   DecoupageAdministratif::Departement.where(code_region: '52')
    def where(criteria)
      all.select { |item| item.send(criteria.keys.first) == criteria.values.first }
    end

    # @param criteria [Hash] a hash with the attributes to filter by
    # @return [Array] an array of all items that match the criteria, case-insensitive
    # This method is useful for string attributes where you want to perform a case-insensitive search.
    # It will return all items where the attribute contains the value, ignoring case.
    # Note: This method assumes that the attribute being searched is a string.
    # @example
    #   DecoupageAdministratif::Commune.where_ilike(nom: 'paris')
    def where_ilike(criteria)
      key = criteria.keys.first
      value = criteria.values.first
      all.select do |item|
        item_value = item.send(key)
        if value.is_a?(String) && item_value.is_a?(String)
          item_value.downcase.include?(value.downcase)
        else
          item_value == value
        end
      end
    end
  end
end
