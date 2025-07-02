# frozen_string_literal: true

module DecoupageAdministratif
  class Epci
    extend BaseModel

    # @!attribute [r] code
    #   @return [String] SIREN code of the EPCI
    # @!attribute [r] nom
    #   @return [String] Name of the EPCI
    # @!attribute [r] membres
    #   @return [Array<Hash>] Members of the EPCI, each member is a hash with "nom" and "code" keys
    attr_reader :code, :nom, :membres

    # @param code [String] the SIREN code of the EPCI
    # @param nom [String] the name of the EPCI
    # @param membres [Array<Hash>] the members of the EPCI, each member is a hash with "nom" and "code" keys
    def initialize(code:, nom:, membres: [])
      @code = code
      @nom = nom
      @membres = membres
    end

    class << self
      # @return [Array<Epci>] a collection of all EPCI
      def all
        Parser.new('epci').data.map do |epci_data|
          Epci.new(
            code: epci_data["code"],
            nom: epci_data["nom"],
            membres: epci_data["membres"].map { |membre| membre.slice("nom", "code") }
          )
        end
      end

      # Search for an EPCI that includes all the specified codes
      # @param codes [Array<String>] an array of commune codes
      # @return [Array<Epci>] a collection of EPCI that include all the specified codes
      def find_by_communes_codes(codes)
        all.select do |epci|
          epci.membres.map do |m|
            # Normally a member is a hash, but sometimes it's a DecoupageAdministratif::Commune (bug handled)
            if m.is_a?(DecoupageAdministratif::Commune)
              codes.include?(m.code)
            else
              codes.include?(m['code'])
            end
          end.all?
        end
      end
    end

    # @return [Array<Commune>] a collection of all communes that are members of the EPCI
    # @raise [TypeError] if a commune code is not found
    def communes
      @communes ||= @membres.map do |membre|
        commune = DecoupageAdministratif::Commune.find_by(code: membre["code"])
        raise TypeError, "Commune not found for code #{membre["code"]}" unless commune.is_a?(DecoupageAdministratif::Commune)

        commune
      end.compact
    end

    # @return [Array<Region>] an array of regions that the EPCI communes belong to
    # Sometimes an EPCI can have communes from different regions.
    def regions
      @regions ||= communes.map(&:region).uniq
    end
  end
end
