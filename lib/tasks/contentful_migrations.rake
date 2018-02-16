namespace :contentful_migrations do

  desc "Migrate the contentful space, runs all pending migrations"
  task :migrate, [:contentful_space] => %i(reset_logger) do |_t, _args|
    # ENV[""]
    ContentfulMigrations::Migrator.run
  end

  desc "Rollback previous migration"
  task :rollback, [:contentful_space] => %i(reset_logger) do |_t, _args|
    # TODO: get it working!
    # ContentfulMigrations::Migrator.run
  end
  desc "List any pending migration"
  task :pending, [:contentful_space] => %i(reset_logger) do |_t, _args|
    # TODO: get it working!
    # ContentfulMigrations::Migrator.run
  end
end
