require 'contentful/management'
require 'forwardable'

module ContentfulMigrations
  # MigrationProxy is used to defer loading of the actual migration classes
  # until they are needed. This implementation is borrowed from activerecord's
  # migration library.

  MigrationProxy = Struct.new(:name, :version, :filename, :scope) do
    extend Forwardable
    def initialize(name, version, filename, scope)
      super
      @migration = nil
    end

    def basename
      File.basename(filename)
    end

    def mtime
      File.mtime filename
    end

    delegate %i[migrate record_migration] => :migration

    private

    def migration
      @migration ||= load_migration
     end

    def load_migration
      require(File.expand_path(filename))
      name.constantize.new(name, version)
     end
  end
end
require 'contentful_migrations/version'
require 'contentful_migrations/utils'
require 'contentful_migrations/migration'
require 'contentful_migrations/migrator'
load 'tasks/contentful_migrations.rake'
