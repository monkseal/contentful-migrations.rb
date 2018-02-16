
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contentful_migrations/version'

Gem::Specification.new do |spec|
  spec.name          = 'contentful-migrations'
  spec.version       = ContentfulMigrations::VERSION
  spec.authors       = ['Kevin English']
  spec.email         = ['me@kenglish.co']

  spec.summary       = 'Contentful Migrations in Ruby'
  spec.description   = 'Migration library system for Contentful API dependent on
                          contentful-management gem and plagarized from activerecord.'
  spec.homepage      = "http://kenglish.co"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir["{lib,vendor}/**/*"]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'contentful-management', '~> 1.10.1'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'byebug', '~> 10.0.0'
end
