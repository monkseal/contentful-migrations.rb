require 'contentful_migrations'
namespace :contentful_migrations do
  desc 'Migrate the contentful space, runs all pending migrations'
  task migrate: :environment do |_t, _args|
    ContentfulMigrations::Migrator.migrate
  end

  desc 'Rollback previous contentful migration'
  task rollback: :environment do |_t, _args|
    ContentfulMigrations::Migrator.rollback
  end

  desc 'List any pending contentful migrations'
  task pending: :environment  do |_t, _args|
    ContentfulMigrations::Migrator.pending
  end
end
