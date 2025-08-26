# frozen_string_literal: true

require_relative "lib/decoupage_administratif/version"

Gem::Specification.new do |spec|
  spec.name = "decoupage_administratif"
  spec.version = DecoupageAdministratif::VERSION
  spec.authors = ["Lucien Mollard"]
  spec.email = ["lucien.mollard@beta.gouv.fr"]

  spec.summary = "French administrative divisions - Découpage administratif français"
  spec.description = "Ruby gem for French administrative divisions (découpage administratif français). Access data about all French communes (municipalities), départements, régions, and EPCIs (intercommunalités). Official data from @etalab/decoupage-administratif."
  spec.homepage = "https://github.com/betagouv/decoupage-administratif-gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/betagouv/decoupage-administratif-gem/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end + Dir.glob("data/*.json")
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
