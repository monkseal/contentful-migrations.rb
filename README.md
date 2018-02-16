# Contentful Migrations


Ruby library for Rails-style migrations using the [Contentful Content Management API](https://github.com/contentful/contentful-management.rb).

## About Contentful

[Contentful](https://www.contentful.com) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

NOTE: This is a 3rd party library and is not maintained by Contentful.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'contentful-migrations'
```

## Usage


### Examples
Some examples can be found in the ```spec/db/contentful_migrations/``` directory of this project [extended example script](https://github.com/contentful/cma_import_script).

### Using the generator

### Running migrations

### Rolling back migrations

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/monkseal/contentful-migrations.rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
