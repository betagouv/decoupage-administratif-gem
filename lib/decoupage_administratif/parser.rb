# frozen_string_literal: true

module DecoupageAdministratif
  class Parser
    attr_reader :data

    def initialize(model)
      @file_path = File.join(File.dirname(__FILE__), "../../data/#{model}.json")
      load_data
    end

    private

    def load_data
      file = File.read(@file_path)
      @data = JSON.parse(file)
    rescue Errno::ENOENT
      raise Error,
            "File #{@file_path} doesn not exist. You have to install the gem with 'rake decoupage_administratif:install'"
    rescue JSON::ParserError
      raise Error, "File #{@file_path} is not valid JSON"
    end
  end
end
