# frozen_string_literal: true

module DecoupageAdministratif
  module BaseModel
    def find_by(criteria)
      all.find { |item| item.send(criteria.keys.first) == criteria.values.first }
    end

    def where(criteria)
      all.select { |item| item.send(criteria.keys.first) == criteria.values.first }
    end

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
