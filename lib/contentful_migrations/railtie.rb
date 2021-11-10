# frozen_string_literal: true

module ContentfulMiagrations
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), '..', 'tasks', 'contentful_migrations.rake')
    end

    generators do
      require_relative "../generators/contentful_migration_generator"
    end
  end
end
