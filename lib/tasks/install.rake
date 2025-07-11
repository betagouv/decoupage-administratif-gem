# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative '../decoupage_administratif/config'

namespace :decoupage_administratif do
  desc 'Update files'
  task :update do
    collection = %w[communes departements regions epci]
    data_dir = DecoupageAdministratif::Config.data_directory
    FileUtils.mkdir_p(data_dir)

    collection.each do |item|
      def download_file(url, destination)
        puts "Downloading from #{url}..."

        uri = URI(url)
        response = Net::HTTP.get_response(uri)

        raise "Download failed with status: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

        File.open(destination, 'wb') do |file|
          file.write(response.body)
        end
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

      begin
        file = File.join(data_dir, "#{item}.json")
        url = "https://unpkg.com/@etalab/decoupage-administratif@4.0.0/data/#{item}.json"
        download_file(url, file)

        puts "Update completed successfully!"
      rescue StandardError => e
        puts "Error during update:"
        puts e.message
        puts e.backtrace
        exit 1
      end
    end
  end

  desc 'Download files'
  task :install do
    data_dir = DecoupageAdministratif::Config.data_directory
    FileUtils.rm_rf(data_dir) if File.directory?(data_dir)
    Rake::Task['decoupage_administratif:update'].invoke
  end
end
