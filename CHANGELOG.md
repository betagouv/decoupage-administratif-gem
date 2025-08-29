## [Unreleased]

## [0.1.1] - 2025-08-29

### Fixed
- Include territory_extensions.rb and territory_strategies.rb files in the gem package
- Fix NoMethodError for `territory_intersects_with_insee_codes?` method in production environments

## [0.1.0] - 2025-08-26

### Added
- Initial release of the DecoupageAdministratif gem
- Support for French administrative divisions:
  - **Communes**: Access to 35,000+ French municipalities with codes, names, and types
  - **Départements**: All French departments with their communes
  - **Régions**: All French regions with departments and communes
  - **EPCIs**: Intercommunal cooperation establishments with member communes
- Query API inspired by ActiveRecord:
  - `find(code)`: Find by code, raises error if not found
  - `find_by(attribute: value)`: Find first match, returns nil if not found
  - `where(criteria)`: Filter with exact or partial matching
  - `all`: Get all records
- Advanced search capabilities:
  - Search territories by INSEE codes
  - Find complete territories (departments, regions, EPCIs) from commune codes
  - Support for partial matching and case-insensitive searches
- Territory intersection methods:
  - `territory_intersects_with_insee_codes?`: Check if territory contains any of the given INSEE codes
  - `territory_insee_codes`: Get all INSEE codes for a territory
- Flexible data configuration:
  - Embedded data files included in the gem
  - Optional custom data directory via `DECOUPAGE_DATA_DIR` environment variable
  - Automatic fallback to user directory or Rails tmp
  - Rake task to update data from official @etalab/decoupage-administratif package
- Performance optimizations:
  - Class-level caching for communes and departments
  - Efficient search algorithms for large datasets
- Full test coverage with RSpec
- YARD documentation for all public methods
- RBS type signatures for type safety
- Rubocop linting configuration
