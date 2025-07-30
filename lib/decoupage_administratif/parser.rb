# frozen_string_literal: true

require 'json'

module DecoupageAdministratif
  class Parser
    # @!attribute [r] data
    #   @return [Array<Hash>] Parsed data from the JSON file for the given model
    attr_reader :data

    # @param model [String] the name of the model to parse (e.g., 'communes', 'departements', 'regions')
    # @return [Parser] a new Parser instance
    # @note Only expected model names should be used to avoid loading unwanted files. The file path is constructed from the model name.
    def initialize(model)
      @model = model
      gem_dir = Gem::Specification.find_by_name('decoupage_administratif').gem_dir
      @file_path = File.join(gem_dir, 'data', "#{@model}.json")
      load_data
    end

    private

    def load_data
      file = File.read(@file_path)
      @data = JSON.parse(file)
    rescue Errno::ENOENT
      raise Error,
            "File #{@file_path} does not exist. You have to install the gem with 'rake decoupage_administratif:install'"
    rescue JSON::ParserError
      raise Error, "File #{@model}.json is not valid JSON"
    end
  end
end
