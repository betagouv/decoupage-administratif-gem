# frozen_string_literal: true

module DecoupageAdministratif
  class Config
    class << self
      # @return [String] the directory where data files are stored
      def data_directory
        @data_directory ||= determine_data_directory
      end

      # @param path [String] the path to set as data directory
      attr_writer :data_directory

      # @return [String] the directory where embedded data files are stored
      def embedded_data_directory
        @embedded_data_directory ||= File.join(gem_root, 'data')
      end

      # @return [String] the root directory of the gem
      def gem_root
        @gem_root ||= File.expand_path('../..', __dir__)
      end

      private

      def determine_data_directory
        ENV['DECOUPAGE_DATA_DIR'] ||
          user_data_directory ||
          fallback_directory
      end

      def user_data_directory
        return nil unless Dir.home

        File.join(Dir.home, '.local', 'share', 'decoupage_administratif')
      end

      def fallback_directory
        if defined?(Rails) && Rails.respond_to?(:root)
          Rails.root.join('tmp', 'decoupage_administratif').to_s
        else
          File.join(Dir.tmpdir, 'decoupage_administratif')
        end
      end
    end
  end
end
