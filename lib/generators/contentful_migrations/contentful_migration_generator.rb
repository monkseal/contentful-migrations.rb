require 'rails/generators'

class ContentfulMigrationGenerator < Rails::Generators::NamedBase
  # source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    name = "#{file_name}"
    migration_file = "db/contentful_migrations/#{next_migration_number}_#{name.underscore}.rb"
    create_file migration_file, <<-FILE.strip_heredoc
      class #{name.camelize} < ContentfulMigration::Migration
        def up

        end
      end
   FILE
  end

  def next_migration_number
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
end
