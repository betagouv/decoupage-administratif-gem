## [Unreleased]

## [0.5.0] - 2026-09-28

### Added
- **Commune**: `actuelle?` predicate, true for current communes and municipal districts (`:commune_actuelle` and `:arrondissement_municipal`)

### Changed
- **BaseModel**: `find` now looks records up through a memoized index by code (`all_by_code`) instead of scanning the whole collection
- **Commune**: when several communes share the same code (e.g. a commune actuelle and a commune déléguée), `Commune.find` now returns the commune actuelle
- **Data**: embedded data updated from @etalab/decoupage-administratif 6.0.0 (was 4.0.0): communes merged or split since the previous release (34,969 current communes, was 35,029), refreshed population figures, EPCI names and members
- **Rake**: source dataset version extracted into the `ETALAB_DATASET_VERSION` constant in `decoupage_administratif:update`
- **CI**: test matrix now covers maintained Ruby versions only (3.3, 3.4, 4.0); Rubocop workflow now runs on Ruby 4.0 (was 2.6)
- **Dependencies**: development dependencies refreshed (Bundler 4.0, RuboCop 1.91, json 3.0) so the bundle installs on Ruby 4.0

### Removed
- **Breaking**: support for Ruby < 3.3 dropped (`required_ruby_version` is now `>= 3.3.0`); Ruby 3.0, 3.1 and 3.2 are end-of-life

### Fixed
- `DecoupageAdministratif::DATA_VERSION` now reports the version of the embedded data (6.0.0, was wrongly `5.2.0`)

## [0.4.0] - 2026-01-27

### Added
- **Commune**: `codes_postaux` attribute exposing postal codes from source data (e.g., `commune.codes_postaux # => ["72110"]`)
- **BaseModel**: `where` now supports filtering on array attributes (e.g., `Commune.where(codes_postaux: ["72110", "72600"])`)

## [0.3.1] - 2025-11-15

### Fixed
- **Departement**: `communes` method now includes municipal districts (arrondissements) in addition to current communes
- **Region**: `communes` method now includes municipal districts (arrondissements) in addition to current communes
- **Search**: `find_communes_by_codes` method now correctly includes municipal districts (arrondissements)

## [0.3.0] - 2025-11-14

### Added
- **BaseModel**: Support for array values in `where` method to filter on multiple values (e.g., `where(commune_type: [:commune_actuelle, :arrondissement_municipal])`)
- **Commune**: Municipal districts (arrondissements of Paris, Lyon, Marseille) are now included in `Commune.actuelles` method
- New commune type `:arrondissement_municipal` for municipal districts

### Changed
- `Commune.actuelles` now returns both current communes and municipal districts (`:commune_actuelle` and `:arrondissement_municipal`)

### Fixed
- RBS type signature for `commune_type` attribute corrected from `String` to `Symbol`

## [0.2.0] - 2025-08-29

### Changed
- **Breaking**: Renamed `territory_intersects_with_insee_codes?` method to `includes_any_commune_code?` for better clarity and consistency with Ruby conventions
- Method now has a more intuitive name that clearly indicates it checks if a territory includes any of the specified commune codes

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
- Territory inclusion methods:
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
