# frozen_string_literal: true

module DecoupageAdministratif
  class Epci
    attr_reader :code, :nom, :membres

    def initialize(code:, nom:, membres: [])
      @code = code
      @nom = nom
      @membres = membres
    end

    class << self
      def all
        EpciCollection.new(Parser.new('epci').data.map do |epci_data|
          Epci.new(
            code: epci_data["code"],
            nom: epci_data["nom"],
            membres: epci_data["membres"].map! { |membre| membre.slice("nom", "code") }
          )
        end)
      end

      def epcis
        @epcis ||= all
      end

      def find_by_code(code)
        epcis.find { |epci| epci.code == code }
      end

      # Cherche une EPCI qui comporte tous les codes précisés
      def find_by_communes_codes(codes)
        DecoupageAdministratif::EpciCollection.new(epcis.select do |epci|
          epci.membres.map do |m|
            code_membre = if m.is_a?(Hash)
                      m["code"]
                    else
                      m.code
                   end
            codes.include?(code_membre)
          end.all?
        end)
      end
    end

    def communes
      @communes ||= DecoupageAdministratif::CommuneCollection.new(@membres.map! do |membre|
        code_membre = if membre.is_a?(Hash)
                 membre["code"]
               else
                 membre.code
               end
        DecoupageAdministratif::Commune.find_by_code(code_membre)
      end)
    end

    def regions
      @regions ||= communes.map(&:region).uniq
    end
  end

  class EpciCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
