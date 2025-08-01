# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative '../decoupage_administratif/config'
require_relative '../decoupage_administratif/version'

def download_file(url, destination)
  puts "Downloading from #{url}..."

  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  raise "Download failed with status: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

  File.binwrite(destination, response.body)
  puts "Successfully downloaded"

  # Validate JSON
  begin
    JSON.parse(File.read(destination))
    puts "JSON validation successful"
  rescue JSON::ParserError => e
    puts "Error: Invalid JSON file downloaded"
    puts e.message
    FileUtils.rm(destination)
    raise "Download failed: Invalid JSON"
  end
end

namespace :decoupage_administratif do
  desc 'Update files'
  task :update do
    collection = %w[communes departements regions epci]
    data_dir = DecoupageAdministratif::Config.data_directory
    FileUtils.mkdir_p(data_dir)

    collection.each do |item|
      file = File.join(data_dir, "#{item}.json")
      url = "https://unpkg.com/#{DecoupageAdministratif::DATA_SOURCE}@#{DecoupageAdministratif::DATA_VERSION}/data/#{item}.json"
      download_file(url, file)

      puts "Update completed successfully!"
    rescue StandardError => e
      puts "Error during update:"
      puts e.message
      puts e.backtrace
      exit 1
    end
  end

  desc 'Download files'
  task :install do
    data_dir = DecoupageAdministratif::Config.data_directory
    FileUtils.rm_rf(data_dir) if File.directory?(data_dir)
    Rake::Task['decoupage_administratif:update'].invoke
  end

  desc 'Show data version information'
  task :info do
    puts "DecoupageAdministratif Gem Information:"
    puts "  Gem version: #{DecoupageAdministratif::VERSION}"
    puts "  Data version: #{DecoupageAdministratif::DATA_VERSION}"
    puts "  Data source: #{DecoupageAdministratif::DATA_SOURCE}"
    puts "  Data directory: #{DecoupageAdministratif::Config.data_directory}"
  end
end
