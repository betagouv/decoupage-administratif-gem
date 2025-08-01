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
      @file_path = File.join(DecoupageAdministratif::Config.data_directory, "#{@model}.json")
      load_data
    end

    private

    def load_data
      file = File.read(@file_path)
      @data = JSON.parse(file)
    rescue Errno::ENOENT
      # Try to load from embedded data if external file not found
      @file_path = File.join(DecoupageAdministratif::Config.embedded_data_directory, "#{@model}.json")
      begin
        file = File.read(@file_path)
        @data = JSON.parse(file)
      rescue Errno::ENOENT
        raise Error,
              "File #{@file_path} does not exist. You can update the data with 'rake decoupage_administratif:update'"
      rescue JSON::ParserError
        raise Error, "File #{@model}.json is not valid JSON"
      end
    rescue JSON::ParserError
      raise Error, "File #{@model}.json is not valid JSON"
    end
  end
end
