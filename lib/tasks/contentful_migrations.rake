namespace :contentful_migrations do
  desc 'Migrate the contentful space, runs all pending migrations'
  task :migrate, [:contentful_space]  do |_t, _args|
    ContentfulMigrations::Migrator.migrate
  end

  desc 'Rollback previous contentful migration'
  task :rollback, [:contentful_space] do |_t, _args|
    ContentfulMigrations::Migrator.rollback
  end

  desc 'List any pending contentful migrations'
  task :pending, [:contentful_space]  do |_t, _args|
    ContentfulMigrations::Migrator.pending
  end
end
