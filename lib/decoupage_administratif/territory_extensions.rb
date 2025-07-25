# frozen_string_literal: true

module DecoupageAdministratif
  module TerritoryExtensions
    # Check if this territory intersects with a list of commune INSEE codes
    # @param commune_insee_codes [Array<String>] array of commune INSEE codes to check against
    # @return [Boolean] true if territory intersects with any of the provided codes
    def territory_intersects_with_insee_codes?(commune_insee_codes)
      territory_strategy.intersects_with_insee_codes?(commune_insee_codes)
    end

    # Get commune INSEE codes for this territory
    # @return [Array<String>] array of commune INSEE codes covered by this territory
    def territory_insee_codes
      @territory_insee_codes ||= territory_strategy.insee_codes
    end

    private

    def territory_strategy
      @territory_strategy ||= case self.class.name.split('::').last
                              when 'Commune'
                                TerritoryStrategies::CommuneStrategy.new(self)
                              when 'Departement'
                                TerritoryStrategies::DepartementStrategy.new(self)
                              when 'Region'
                                TerritoryStrategies::RegionStrategy.new(self)
                              when 'Epci'
                                TerritoryStrategies::EpciStrategy.new(self)
                              else
                                raise NotImplementedError, "Territory strategy not implemented for #{self.class.name}"
                              end
    end
  end
end
