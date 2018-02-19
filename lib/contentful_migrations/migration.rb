module ContentfulMigrations
  class Migration
    attr_reader :name, :version, :contentful_client, :contentful_space

    def initialize(name = self.class.name, version = nil, client = nil, space = nil)
      @name       = name
      @version    = version
      @contentful_client = client
      @contentful_space = space
    end

    def migrate(direction, client, space)
      @contentful_client = client
      @contentful_space = space
      send(direction)
      self
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

    def erase_migration(migration_content_type)
      entry = migration_content_type.entries.all.find { |m| m.version.to_i == version.to_i }
      return unless entry
      entry.unpublish
      entry.destroy
      entry
    end
  end
end
