# lib/decoupage_administratif/version.rb
# frozen_string_literal: true

module DecoupageAdministratif
  VERSION = "0.1.0"
end

# decoupage_administratif.gemspec
# frozen_string_literal: true

require_relative "lib/decoupage_administratif/version"

Gem::Specification.new do |spec|
  spec.name = "decoupage_administratif"
  spec.version = DecoupageAdministratif::VERSION
  spec.authors = ["Lucien"]
  spec.email = ["lucien.mollard@beta.gouv.fr"]

  spec.summary = "Accès aux données du découpage administratif français"
  spec.description = "Une bibliothèque Ruby pour accéder aux données de communes, départements, régions et EPCIs de France"
  spec.homepage = "https://github.com/betagouv/decoupage-administratif-gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/betagouv/decoupage-administratif-gem/changelog.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rubocop", "~> 1.21"
end