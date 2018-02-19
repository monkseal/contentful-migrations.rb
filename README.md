# Contentful Migrations

Ruby library for Rails/ActiveRecord style migrations using the [Contentful Content Management API](https://github.com/contentful/contentful-management.rb).

## About Contentful

[Contentful](https://www.contentful.com) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

NOTE: This is a 3rd party library and is not maintained by Contentful.

## About Contentful's contentful-management Gem

The [Contentful Content Management](https://github.com/contentful/contentful-management.rb) gem is a Ruby client for the Contentful Content Management API and a dependency of this project. _This library provides a mimimal DSL for migrations only_. Any migrations you write must make use of the ruby api provided by `contentful-management.rb`. Before using this library, make sure you are familiar with contentful and are able to use their library, see [contentful-management.rb Usage]( https://github.com/contentful/contentful-management.rb#usage)

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'contentful-migrations'
```

## How it works

*Contentful Migrations* creates a new content model in your contentful space called `migrations`. This model is queried each time you run the migration to determine if it has been run before or not. In order for the library to work, you should never delete this `migrations`. You might want to change the permissions on the model so it is only visible to users with the `admin` role.


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

### Configuration

At this time, this gem does not provide a configuration block, object or initializer. You must configure it using the following environment variables:

```
CONTENTFUL_MANAGEMENT_ACCESS_TOKEN # Contentful Access token to you management API
CONTENTFUL_SPACE_ID # Cotentful SpaceID value
MIGRATION_PATH # [Optional] migration path, defaults to db/contentful_migrations
```
An easy way to deal with this is to use  [foreman](https://github.com/ddollar/foreman). You can create local `.env` in the root folder of your project, for example:
```
CONTENTFUL_MANAGEMENT_ACCESS_TOKEN="my_management_token"
CONTENTFUL_SPACE_ID="my_space_id"
```

Then run the below tasks with `foreman run`:
```
foreman run rake contentful_migrations:rollback
```

### Running migrations
Once you have created a new migration, you can run it using the following rake task:

```
rake contentful_migrations:migrate
```

### Rolling back migrations
Migrations can be rolled back _one at a time_ with the following:

```
rake contentful_migrations:rollback
```

### Pending migrations

You can view pending migrations:

```
rake  contentful_migrations:pending
```

## Migration API
Currently supported are two method to directly access objects from the contentful-management api:

### `with_space`

Provides a block with the [space](https://github.com/contentful/contentful-management.rb#spaces) for your migration. Here is an example of how you would use this to create a simple up/down migration:

```
class BuildTestContent < ContentfulMigrations::Migration
  def up
    with_space do |space|
      ### Create the content model
      content_type = space.content_types.create(
        name: 'Test Content',
        id: 'testContent',
        description: 'A Test Content Type'
      )
      ### Create the content fields
      content_type.fields.create(id: 'name', name: 'name', type: 'Symbol', required: true)
      content_type.fields.create(id: 'content', name: 'content', type: 'Text')
      content_type.save
      content_type.publish
    end
  end

  def down
    with_space do |space|
      content_type = space.content_types.find('testContent')
      content_type.unpublish
      content_type.destroy
    end
  end
end
```
### `with_editor_interfaces`

This provides access to the [editor interface](https://github.com/contentful/contentful-management.rb#editor-interface) object. It is best used embedded inside a `with_space` block as follows:

```
class BuildTestContent < ContentfulMigrations::Migration
  def up
    with_space do |space|
      # Set the editor interface for *name* field to *radio
      with_editor_interfaces do |editor_interfaces|
        editor_interface = editor_interfaces.default(space.id, 'testContent')
        controls = editor_interface.controls.map do |control|
          control["widgetId"] = "radio" if control["fieldId"] == "name"
          control
        end
        editor_interface.update(controls: controls)
        editor_interface.reload
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/monkseal/contentful-migrations.rb.

## Author

**Kevin English**

* [github/monkseal](https://github.com/monkseal): Follow me on GitHub for project updates
* [kenglish.co](http://kenglish.co): Visit my website
* [kenglish.co/blog](http://kenglish.co/blog): Follow my blog

If you'd like to get in touch regarding a speaking engagement or consulting opportunity, please use the email address on my GitHub profile. Thanks!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
