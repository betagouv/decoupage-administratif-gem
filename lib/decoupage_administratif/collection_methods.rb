# frozen_string_literal: true

module DecoupageAdministratif
  module CollectionMethods
    # @return [Array<String>] an array of codes of the items in the collection
    def codes
      map(&:code)
    end

    # @return the first item in the collection
    def first(number = nil)
      if number.nil?
        super()
      else
        self.class.new(super)
      end
    end

    # @return the last item in the collection
    def last(number = nil)
      if number.nil?
        super()
      else
        self.class.new(super)
      end
    end
  end
end
