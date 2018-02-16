# Contentful Migrations


Ruby library for Rails-style migrations using the [Contentful Content Management API](https://github.com/contentful/contentful-management.rb).

## About Contentful

[Contentful](https://www.contentful.com) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

NOTE: This is a 3rd party library and is not maintained by Contentful.

## About Contentful's contentful-management Gem

The [Contentful Content Management](https://github.com/contentful/contentful-management.rb) gem is a Ruby client for the Contentful Content Management API and a dependency of this project. _This library provides a mimimal DSL for migrations only_. Any migrations you write must make use of `contentful-management.rb`. Before using this library, make sure you are familiar with contentful and are able to use their library, see [contentful-management.rb Usage]( https://github.com/contentful/contentful-management.rb#usage)

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'contentful-migrations'
```

## Usage

### Examples
Some example migrations can be found in the [```spec/db/contentful_migrations/```](https://github.com/monkseal/contentful-migrations.rb/tree/master/spec/db/contentful_migrations) directory of this project.

### Using the Rails generator

If you are using [Ruby on Rails ](http://api.rubyonrails.org/), you can generate new contentful migrations using a rails generator as follows:
```
rails g contentful_migration [migration_desc]
```
Where `[migration_desc]` is the an underscored description of the migration you'd like to create.

For example:
```
rails g contentful_migration new_content_model
```

This will generate a file `db/contentful_migrations/xxxxxx_new_content_model.rb` where `xxxx` is the timestamp for the file generated.

### Running migrations

### Rolling back migrations

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/monkseal/contentful-migrations.rb.

### Author

**Kevin English**

* [github/monkseal](https://github.com/monkseal): Follow me on GitHub for project updates
* [kenglish.co](http://kenglish.co): Visit my website
* [kenglish.co/blog](http://kenglish.co/blog): Follow my blog

If you'd like to get in touch regarding a speaking engagement or consulting opportunity, please use the email address on my GitHub profile. Thanks!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
