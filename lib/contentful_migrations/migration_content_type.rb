module ContentfulMigrations
  class MigrationContentType
    DEFAULT_MIGRATION_CONTENT_TYPE = 'migrations'.freeze

    attr_reader :access_token, :space_id, :client, :space,
                :migration_content_type_name, :logger

    def initialize(client:,
                   space:,
                   logger:,
                   migration_content_type_name: DEFAULT_MIGRATION_CONTENT_TYPE)
      @client = client
      @space = space
      @logger = logger
      @migration_content_type_name = migration_content_type_name
    end

    def resolve
      @migration_content_type ||= find_or_create_migration_content_type
    end

    private

    def find_or_create_migration_content_type
      content_type = space.content_types.find(migration_content_type_name)
      if content_type.nil? || content_type.is_a?(Contentful::Management::Error)
        build_migration_content_type
      else
        content_type
      end
    end

    def build_migration_content_type
      content_type = space.content_types.create(
        name: migration_content_type_name,
        id: migration_content_type_name,
        description: 'Migration Table for interal use only, do not delete'
      )
      content_type.fields.create(id: 'version', name: 'version', type: 'Integer')
      content_type.save
      content_type.publish
      content_type
    end
  end
end
