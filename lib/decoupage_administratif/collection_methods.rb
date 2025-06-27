# frozen_string_literal: true

module DecoupageAdministratif
  module CollectionMethods
    def codes
      map(&:code)
    end

    def first(number = nil)
      if number.nil?
        super()
      else
        self.class.new(super)
      end
    end

    def last(number = nil)
      if number.nil?
        super()
      else
        self.class.new(super)
      end
    end
  end
end
