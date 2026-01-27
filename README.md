[![Gem Version](https://badge.fury.io/rb/decoupage_administratif.svg)](https://badge.fury.io/rb/decoupage_administratif)

# DecoupageAdministratif
English version below

Gem Ruby permettant d’accéder facilement aux données du découpage administratif français (régions, départements, communes, EPCI) à partir des jeux de données de Datagouv : <https://github.com/datagouv/decoupage-administratif>.

## Territoires couverts 
- Régions
- Départements
- Communes
- EPCI (Établissements Publics de Coopération Intercommunale)

## Installation

Ajoutez la gem à votre Gemfile :

    bundle add decoupage_administratif

Ou installez-la directement :

    gem install decoupage_administratif

Mise à jour des données (optionnel) :

    rake decoupage_administratif:update

### Configuration

**Données embarquées :** La gem inclut maintenant les données par défaut et fonctionne directement sans installation additionnelle.

**Données personnalisées :** Vous pouvez utiliser des données plus récentes en les téléchargeant :

```bash
# Mettre à jour vers les dernières données (optionnel)
rake decoupage_administratif:update
```

**Répertoire personnalisé :**
```bash
# Via variable d'environnement
export DECOUPAGE_DATA_DIR=/path/to/your/data/directory
rake decoupage_administratif:update
```

```ruby
# Via code (pour Rails)
# config/initializers/decoupage_administratif.rb
DecoupageAdministratif::Config.data_directory = Rails.root.join('tmp', 'decoupage_data')
```

**Ordre de priorité :**
1. Données dans le répertoire personnalisé (`DECOUPAGE_DATA_DIR`)
2. Données dans `~/.local/share/decoupage_administratif/`
3. **Données embarquées dans la gem** (fallback automatique)

## Utilisation

Exemple d’utilisation basique :

```ruby
# Lister toutes les régions
DecoupageAdministratif::Region.all

# Trouver une commune par code INSEE
# Une commune a un commune_type qui peut être :commune_actuelle, :commune_deleguee (anciennes communes), :commune_associee (anciennes communes avec un statut spécial) ou :arrondissement_municipal (arrondissements de Paris, Lyon, Marseille)
commune = DecoupageAdministratif::Commune.find('75056')
puts commune.nom # => "Paris"

# Lister toutes les communes actuelles (communes actuelles + arrondissements municipaux)
DecoupageAdministratif::Commune.actuelles

# Lister les départements d'une région
DecoupageAdministratif::Region.find('84').departements

# Lister toutes les communes actuelles d’un département
departement = DecoupageAdministratif::Departement.find('72')
puts departement.communes

# Trouver un EPCI par son SIREN
epci = DecoupageAdministratif::Epci.find('200054781')
puts epci.nom

# Lister les communes d’un EPCI
puts epci.communes

# Rechercher une commune par nom (insensible à la casse)
DecoupageAdministratif::Commune.where(nom: 'paris', case_insensitive: true)

# Rechercher des communes par codes postaux
DecoupageAdministratif::Commune.where(codes_postaux: ['72110', '72600'])

# Lister les départements d'une région
region = DecoupageAdministratif::Region.find_by(nom: 'Bretagne')
puts region.departements
```

### Extensions territoriales

La gem propose des méthodes pour vérifier la correspondance entre territoires et listes de codes INSEE :

```ruby
# Vérifier si un territoire contient au moins une commune d'une liste
commune_codes = ['75001', '75002', '69001']
departement = DecoupageAdministratif::Departement.find('75')
departement.includes_any_commune_code?(commune_codes) # => true

# Obtenir tous les codes INSEE des communes d'un territoire
departement.territory_insee_codes # => ["75001", "75002", "75003", ...]
```

## Développement

Build la gem après avoir cloné le dépôt :

    gem build decoupage_administratif.gemspec

Installer la gem localement :

    bundle exec rake install

Vérifier la version installée :

    ruby -r 'decoupage_administratif' -e 'puts DecoupageAdministratif::VERSION'

Mettre à jour les données (optionnel) :

    rake decoupage_administratif:update

Pour lancer les tests :

    rake spec

Pour une console interactive :

    bin/console

Puis importer la gem :

    require 'decoupage_administratif'

Pour publier une nouvelle version :

- Mettez à jour le numéro de version dans `lib/decoupage_administratif/version.rb`
- Exécutez :

      bundle exec rake release

### Yard

Cette gem utilise [Yard](https://yardoc.org/) pour la documentation. Pour générer la documentation, exécutez :

    yard doc

pour lancer le serveur de documentation, exécutez :

    yard server

Vous pouvez ensuite accéder à la documentation à l'adresse : <http://localhost:8808>.

## Contribution

Les issues et pull requests sont les bienvenues sur : <https://github.com/BetaGouv/decoupage_administratif>

## Licence

Ce projet est sous licence [MIT](https://opensource.org/licenses/MIT).

Données : © Etalab, disponibles sous licence ouverte.

## English version

Ruby gem to easily access French administrative division data (regions, departments, municipalities, EPCI) from official datasets: <https://github.com/datagouv/decoupage-administratif>.

## Covered territories
- Regions
- Departments
- Municipalities (communes)
- EPCI (Public Establishments for Inter-municipal Cooperation)

## Installation

Add the gem to your Gemfile:

    bundle add decoupage_administratif

Or install it directly:

    gem install decoupage_administratif

Update data files (optional):

    rake decoupage_administratif:update

### Configuration

**Embedded data:** The gem now includes default data and works directly without additional installation.

**Custom data:** You can use more recent data by downloading it:

```bash
# Update to latest data (optional)
rake decoupage_administratif:update
```

**Custom directory:**
```bash
# Via environment variable
export DECOUPAGE_DATA_DIR=/path/to/your/data/directory
rake decoupage_administratif:update
```

```ruby
# Via code (for Rails)
# config/initializers/decoupage_administratif.rb
DecoupageAdministratif::Config.data_directory = Rails.root.join('tmp', 'decoupage_data')
```

**Priority order:**
1. Data in custom directory (`DECOUPAGE_DATA_DIR`)
2. Data in `~/.local/share/decoupage_administratif/`
3. **Embedded data in the gem** (automatic fallback)

## Usage

Basic usage example:

```ruby
# List all regions
DecoupageAdministratif::Region.all

# Find a municipality by INSEE code
# A municipality has a `commune_type` which can be :commune_actuelle (current municipalities), :commune_deleguee (former municipalities), :commune_associee (former municipalities with a special status), or :arrondissement_municipal (municipal districts of Paris, Lyon, Marseille)
commune = DecoupageAdministratif::Commune.find('75056')
puts commune.nom # => "Paris"

# List all current municipalities (current communes + municipal districts)
DecoupageAdministratif::Commune.actuelles

# List departments of a region
DecoupageAdministratif::Region.find('84').departements

# List all current municipalities of a department
departement = DecoupageAdministratif::Departement.find('72')
puts departement.communes

# Find an EPCI by its SIREN
epci = DecoupageAdministratif::Epci.find('200054781')
puts epci.nom

# List municipalities of an EPCI
puts epci.communes

# Search for a municipality by name (case-insensitive)
DecoupageAdministratif::Commune.where(nom: 'paris', case_insensitive: true)

# Search municipalities by postal codes
DecoupageAdministratif::Commune.where(codes_postaux: ['72110', '72600'])

# List departments of a region
region = DecoupageAdministratif::Region.find_by(nom: 'Bretagne')
puts region.departements
```

### Territory extensions

The gem provides methods to check if territories include specific commune codes:

```ruby
# Check if a territory includes any of the specified municipality codes
commune_codes = ['75001', '75002', '69001']
departement = DecoupageAdministratif::Departement.find('75')
departement.includes_any_commune_code?(commune_codes) # => true

# Get all INSEE codes of municipalities in a territory
departement.territory_insee_codes # => ["75001", "75002", "75003", ...]
```

## Development

Build the gem after cloning the repository:
    gem build decoupage_administratif.gemspec

Install the gem locally:

    bundle exec rake install

Check the installed version:

    ruby -r 'decoupage_administratif' -e 'puts DecoupageAdministratif::VERSION'

Update the data:

    rake decoupage_administratif:update

To run the tests:
    rake spec

For an interactive console :

    bin/console

Then import the gem :

    require 'decoupage_administratif'

To publish a new version :

- Update the version number in `lib/decoupage_administratif/version.rb`
- Run :

      bundle exec rake release

### Yard

This gem uses [Yard](https://yardoc.org/) for documentation. To generate the documentation, run:

    yard doc

to start the documentation server, run:

    yard server

You can then access the documentation at: <http://localhost:8808>.

## Contribution

Issues and pull requests are welcome at : <https://github.com/BetaGouv/decoupage_administratif>

## License

This project is licensed under the [MIT](https://opensource.org/licenses/MIT) license.

Data : © Etalab, available under open license.
