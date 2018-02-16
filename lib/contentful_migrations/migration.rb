module ContentfulMigrations
  class Migration
    attr_reader :name, :version, :contentful_client, :contentful_space

    def initialize(name = self.class.name, version = nil)
      @name       = name
      @version    = version
      @contentful_client = nil
      @contentful_space = nil
    end

    def migrate(client, space)
      @contentful_client = client
      @contentful_space = space
      up
    end

    def with_space
      yield(contentful_space)
    end

    def with_editor_interfaces
      yield(contentful_client.editor_interfaces)
    end

    def record_migration(migration_content_type)
      entry = migration_content_type.entries.create(version: version)
      entry.save
      entry.publish
      entry
    end
  end
end
