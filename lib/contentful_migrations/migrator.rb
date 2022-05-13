module ContentfulMigrations
  class Migrator
    include Utils

    class InvalidMigrationPath < StandardError #:nodoc:
      def initialize(migrations_path)
        super("#{migrations_path} is not a valid directory.")
      end
    end

    DEFAULT_MIGRATION_PATH = 'db/contentful_migrations'.freeze

    def self.migrate(args = {})
      new(parse_options(args)).migrate
    end

    def self.rollback(args = {})
      new(parse_options(args)).rollback
    end

    def self.pending(args = {})
      new(parse_options(args)).pending
    end

    attr_reader :migrations_path, :access_token, :space_id, :client, :space, :env_id,
                :migration_content_type_name, :logger, :page_size

    def initialize(migrations_path:,
                   access_token:,
                   space_id:,
                   migration_content_type_name:,
                   logger:,
                   env_id: nil)
      @migrations_path = migrations_path
      @access_token = access_token
      @logger = logger
      @space_id = space_id
      @migration_content_type_name = migration_content_type_name
      @client = Contentful::Management::Client.new(access_token, {
        raise_errors: true,
      })
      @env_id = env_id || ENV['CONTENTFUL_ENV'] || 'master'
      @space = @client.environments(space_id).find(@env_id)
      @page_size = 1000
      validate_options
    end

    def migrate
      runnable = migrations(migrations_path).reject { |m| ran?(m) }
      if runnable.empty?
        logger.info('No migrations to run, everything up to date!')
      end

      runnable.each do |migration|
        logger.info("running migration #{migration.version} #{migration.name} ")
        migration.migrate(:up, client, space)
        migration.record_migration(migration_content_type)
      end
      self
    end

    def rollback
      already_migrated = migrations(migrations_path).select { |m| ran?(m) }
      migration = already_migrated.pop
      logger.info("Rolling back migration #{migration.version} #{migration.name} ")
      migration.migrate(:down, client, space)
      migration.erase_migration(migration_content_type)
    end

    def pending
      runnable = migrations(migrations_path).reject { |m| ran?(m) }

      runnable.each do |migration|
        logger.info("Pending #{migration.version} #{migration.name} ")
      end
    end

  private

    def self.parse_options(args)
      {
        migrations_path: ENV.fetch('MIGRATION_PATH', DEFAULT_MIGRATION_PATH),
        access_token: ENV['CONTENTFUL_MANAGEMENT_ACCESS_TOKEN'],
        space_id: ENV['CONTENTFUL_SPACE_ID'],
        migration_content_type_name: MigrationContentType::DEFAULT_MIGRATION_CONTENT_TYPE,
        logger: Logger.new(STDOUT)
      }.merge(args)
    end

    def validate_options
      raise InvalidMigrationPath, migrations_path unless File.directory?(migrations_path)
    end

    def ran?(migration)
      migrated.include?(migration.version.to_i)
    end

    def migrated
      @migrated ||= load_migrated
    end

    def load_migrated
      entries = []
      args = {
        limit: @page_size,
        skip: entries.count
      }
      page = fetch_page(args)
      entries.concat(page)
      if page.size == @page_size
        load_migrated
      else
        entries
      end
    end

    def fetch_page(args)
      migration_content_type.entries.all(args).map { |m| m.version.to_i }
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
      @migration_content_type ||= MigrationContentType.new(
        space: space, client: client, logger: logger
      ).resolve
    end

    MIGRATION_FILENAME_REGEX = /\A([0-9]+)_([_a-z0-9]*)\.?([_a-z0-9]*)?\.rb\z/

    def parse_migration_filename(filename)
      File.basename(filename).scan(MIGRATION_FILENAME_REGEX).first
    end
  end
end
