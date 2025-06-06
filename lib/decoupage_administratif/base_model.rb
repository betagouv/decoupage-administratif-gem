module DecoupageAdministratif
  module BaseModel
    def find_by(criteria)
      all.find { |item| item.send(criteria.keys.first) == criteria.values.first }
    end

    def where(criteria)
      all.select { |item| item.send(criteria.keys.first) == criteria.values.first }
    end
  end
end
