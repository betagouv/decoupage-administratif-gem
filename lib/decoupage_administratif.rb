# frozen_string_literal: true

require_relative "decoupage_administratif/version"
require_relative "decoupage_administratif/config"
require_relative "decoupage_administratif/base_model"
require_relative "decoupage_administratif/territory_strategies"
require_relative "decoupage_administratif/territory_extensions"
require_relative "decoupage_administratif/parser"
require_relative "decoupage_administratif/commune"
require_relative "decoupage_administratif/departement"
require_relative "decoupage_administratif/region"
require_relative "decoupage_administratif/epci"
require_relative "decoupage_administratif/search"

require 'decoupage_administratif/railtie' if defined?(Rails)

module DecoupageAdministratif
  class Error < StandardError; end

  class NotFoundError < Error
    attr_reader :code

    def initialize(message, code:)
      @code = code
      super(message)
    end
  end

  # Returns information about the embedded data version
  # @return [String] formatted string with data version information
  def self.data_info
    "Data version: #{DATA_VERSION} (from #{DATA_SOURCE})"
  end
end
