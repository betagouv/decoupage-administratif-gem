# frozen_string_literal: true

require_relative "decoupage_administratif/version"
require_relative "decoupage_administratif/collection_methods"
require_relative "decoupage_administratif/parser"
require_relative "decoupage_administratif/commune"
require_relative "decoupage_administratif/departement"
require_relative "decoupage_administratif/region"
require_relative "decoupage_administratif/epci"

require 'decoupage_administratif/railtie' if defined?(Rails)

module DecoupageAdministratif
  class Error < StandardError; end
end
