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
