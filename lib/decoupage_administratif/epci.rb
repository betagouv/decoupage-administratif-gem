# frozen_string_literal: true

module DecoupageAdministratif
  class Epci
    extend BaseModel
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

      # Returns a collection of all EPCI.
      def epcis
        @epcis ||= all
      end

      # Search for an EPCI that includes all the specified codes
      def find_by_communes_codes(codes)
        DecoupageAdministratif::EpciCollection.new(epcis.select do |epci|
          epci.membres.map do |m|
            # Normaly a member is a hash but sometimes it's a DecoupageAdministratif::Commune
            # It's a bug
            if m.is_a?(DecoupageAdministratif::Commune)
              codes.include?(m.code)
            else
              codes.include?(m['code'])
            end
          end.all?
        end)
      end
    end

    # Return a collection of all communes in the EPCI.
    def communes
      @communes ||= DecoupageAdministratif::CommuneCollection.new(@membres.map! do |membre|
        DecoupageAdministratif::Commune.find_by(code: membre["code"])
      end)
    end

    # Return the regions of the Epci.
    # Sometimes an EPCI can have communes from different regions.
    def regions
      @regions ||= communes.map(&:region).uniq
    end
  end

  class EpciCollection < Array
    include DecoupageAdministratif::CollectionMethods
  end
end
