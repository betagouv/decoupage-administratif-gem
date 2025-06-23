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

Téléchargez les fichiers :

    rake decoupage_administratif:install


## Utilisation

Exemple d’utilisation basique :

```ruby
# Lister toutes les régions
DecoupageAdministratif::Region.all

# Trouver une commune par code INSEE
commune = DecoupageAdministratif::Commune.find('75056')
puts commune.nom # => "Paris"

# Lister les départements d'une région
DecoupageAdministratif::Region.find('84').departements

# Lister toutes les communes d’un département
departement = DecoupageAdministratif::Departement.find('72')
puts departement.communes

# Trouver un EPCI par son SIREN
epci = DecoupageAdministratif::Epci.find('200054781')
puts epci.nom

# Lister les communes d’un EPCI
puts epci.communes

# Rechercher une commune par nom (insensible à la casse)
DecoupageAdministratif::Commune.search('paris')

# Lister les départements d’une région
region = DecoupageAdministratif::Region.search('Bretagne').first
puts region.departements
```

## Développement

Après avoir cloné le dépôt :

    bin/setup

Pour lancer les tests :

    rake spec

Pour une console interactive :

    bin/console

Pour installer la gem localement :

    bundle exec rake install

Pour publier une nouvelle version :

- Mettez à jour le numéro de version dans `lib/decoupage_administratif/version.rb`
- Exécutez :

      bundle exec rake release

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

Download the data files:

    rake decoupage_administratif:install

## Usage

Basic usage example:

```ruby
# List all regions
DecoupageAdministratif::Region.all

# Find a municipality by INSEE code
commune = DecoupageAdministratif::Commune.find('75056')
puts commune.nom # => "Paris"

# List departments of a region
DecoupageAdministratif::Region.find('84').departements

# List all municipalities of a department
departement = DecoupageAdministratif::Departement.find('72')
puts departement.communes

# Find an EPCI by its SIREN
epci = DecoupageAdministratif::Epci.find('200054781')
puts epci.nom

# List municipalities of an EPCI
puts epci.communes

# Search for a municipality by name (case-insensitive)
DecoupageAdministratif::Commune.search('paris')

# List departments of a region
region = DecoupageAdministratif::Region.search('Bretagne').first
puts region.departements
```

## Development

After cloning the repository :

    bin/setup

To run the tests :

    rake spec

For an interactive console :

    bin/console

To install the gem locally :

    bundle exec rake install

To publish a new version :

- Update the version number in `lib/decoupage_administratif/version.rb`
- Run :

      bundle exec rake release

## Contribution

Issues and pull requests are welcome at : <https://github.com/BetaGouv/decoupage_administratif>

## License

This project is licensed under the [MIT](https://opensource.org/licenses/MIT) license.

Data : © Etalab, available under open license.
