# frozen_string_literal: true

require 'json'

module DecoupageAdministratif
  class Parser
    attr_reader :data

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
            "File #{@file_path}.json does not exist. You have to install the gem with 'rake decoupage_administratif:install'"
    rescue JSON::ParserError
      raise Error, "File #{@model}.json is not valid JSON"
    end
  end
end
