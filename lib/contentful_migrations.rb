require 'contentful/management'
require 'contentful_migrations/utils'
require 'contentful_migrations/version'
require 'contentful_migrations/migration_content_type'
require 'contentful_migrations/migration_proxy'
require 'contentful_migrations/migration'
require 'contentful_migrations/migrator'

load 'tasks/contentful_migrations.rake' if defined?(Rails)
