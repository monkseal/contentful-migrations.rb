module ContentfulMigrations
  class Migrator
    include Utils
    class InvalidMigrationPath < StandardError #:nodoc:
      def initialize(migrations_path)
        super("#{migrations_path} is not a valid directory.")
      end
    end

    DEFAULT_MIGRATION_CONTENT_TYPE = "migrations".freeze

    def self.run(args = {})
      options = {
        migrations_path: "db/contentful_migrations",
        access_token: ENV["CONTENTFUL_MANAGEMENT_ACCESS_TOKEN"],
        space_id: ENV["CONTENTFUL_SPACE_ID"],
        migration_content_type_name: DEFAULT_MIGRATION_CONTENT_TYPE,
        logger: Logger.new(STDOUT)
      }.merge(args)
      new(options).start
    end

    attr_reader :migrations_path, :access_token, :space_id, :client, :space,
                :migration_content_type_name, :logger

    def initialize(migrations_path:,
                   access_token:,
                   space_id:,
                   migration_content_type_name:,
                   logger:)
      @migrations_path = migrations_path
      @access_token = access_token
      @logger = logger
      @space_id = space_id
      @migration_content_type_name = migration_content_type_name
      @client = Contentful::Management::Client.new(access_token)
      @space = @client.spaces.find(space_id)
      validate_options
    end

    def start
      runnable = migrations(migrations_path).reject { |m| ran?(m) }
      if runnable.empty?
        logger.info("No migrations to run, everything up to date!")
      end
      runnable.each do |migration|
        logger.info("running migration #{migration.version}")
        migration.migrate(client, space)
        migration.record_migration(migration_content_type)
      end
    end

  private
    def validate_options
      fail InvalidMigrationPath.new(migrations_path) unless File.directory?(migrations_path)
    end

    def ran?(migration)
      migrated.include?(migration.version.to_i)
    end

    def migrated
      @migrated ||= load_migrated
    end

    def load_migrated
      migration_content_type.entries.all.map { |m| m.version.to_i }
    end

    def migrations(paths)
      paths = Array(paths)
      migrations = migration_files(paths).map do |file|
        version, name, scope = parse_migration_filename(file)
        ContentfulMigrations::MigrationProxy.new(camelize(name), version.to_i, file, scope)
      end

      migrations.sort_by(&:version)
    end

    def migration_files(paths)
      Dir[*paths.flat_map { |path| "#{path}/**/[0-9]*_*.rb" }]
    end

    def migration_content_type
      @migration_content_type ||= find_or_create_migration_content_type
    end

    def find_or_create_migration_content_type
      content_type = space.content_types.find(migration_content_type_name)
      if content_type.is_a?(Contentful::Management::Error)
        build_migration_content_type
      else
        content_type
      end
    end

    def build_migration_content_type
      content_type = space.content_types.create(
        name: migration_content_type_name,
        id: migration_content_type_name,
        description: "Migration Table for interal use only, do not delete"
      )
      content_type.fields.create(id: "version", name: "version", type: "Integer")
      content_type.save
      content_type.publish
      content_type
    end

    MIGRATION_FILENAME_REGEX = /\A([0-9]+)_([_a-z0-9]*)\.?([_a-z0-9]*)?\.rb\z/

    def parse_migration_filename(filename)
      File.basename(filename).scan(MIGRATION_FILENAME_REGEX).first
    end
  end
end
