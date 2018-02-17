require 'forwardable'
require 'contentful_migrations/utils'

module ContentfulMigrations
  # MigrationProxy is used to defer loading of the actual migration classes
  # until they are needed. This implementation is borrowed from activerecord's
  # migration library.

  MigrationProxy = Struct.new(:name, :version, :filename, :scope) do
    extend Forwardable
    include Utils

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

    delegate %i[migrate record_migration erase_migration] => :migration

    private

    def migration
      @migration ||= load_migration
     end

    def load_migration
      require(File.expand_path(filename))
      constantize(name).new(name, version)
     end
  end
end
