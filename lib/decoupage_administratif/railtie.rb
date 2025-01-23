# frozen_string_literal: true

require 'rails'

module DecoupageAdministratif
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/install.rake'
    end
  end
end
