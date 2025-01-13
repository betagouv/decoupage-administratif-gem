# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'FileUtils'

DATA_DIR = File.join('data', 'decoupage_administratif')

namespace :decoupage_administratif do
  desc 'Download files'
  task :install do
    collection = %w[communes departements regions arrondissements epci ept]
    FileUtils.mkdir_p(DATA_DIR)

    collection.each do |item|
      def download_file(url, destination)
        puts "Downloading from #{url}..."

        uri = URI(url)
        response = Net::HTTP.get_response(uri)

        unless response.is_a?(Net::HTTPSuccess)
          raise "Download failed with status: #{response.code} #{response.message}"
        end

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
        file = File.join(DATA_DIR, "#{item}.json")
        url = "https://unpkg.com/@etalab/decoupage-administratif@4.0.0/data/#{item}.json"
        download_file(url, file)

        puts "Installation completed successfully!"
      rescue StandardError => e
        puts "Error during installation:"
        puts e.message
        puts e.backtrace
        exit 1
      end
    end
  end

  desc 'Update files'
  task :update do
    FileUtils.rm_rf(DATA_DIR) if File.directory?(DATA_DIR)
    Rake::Task['decoupage_administratif:install'].invoke
  end
end
