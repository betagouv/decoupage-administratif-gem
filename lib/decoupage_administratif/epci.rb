# frozen_string_literal: true

module DecoupageAdministratif
  class Epci
    attr_reader :code, :nom

    def initialize(code:, nom:)
      @code = code
      @nom = nom
    end

    class << self
      def all
        Parser.new('epcis').data.map do |epci_data|
          Epci.new(
            code: epci_data["code"],
            nom: epci_data["nom"]
          )
        end
      end

      def epcis
        @epcis ||= all
      end

      def find_by_code(code)
        epcis.find { |epci| epci.code == code }
      end
    end
  end
end
