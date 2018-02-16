class BuildMenuItem < ContentfulMigration::Migration
  def up
    with_space do |space|
      ### Create the content model
      content_type = space.content_types.create(
        name: "Menu Item",
        id: "menuItem",
        description: "An Item for a Menu"
      )
      ### Create the content fields
      content_type.fields.create(id: "text", name: "Text", type: "Symbol", required: true)
      content_type.fields.create(id: "path", name: "path", type: "Symbol")
      validation_link_content_type = Contentful::Management::Validation.new
      validation_link_content_type.link_content_type = ["menuItem"]

      content_type.fields.create(id: "menuItems",
                                 name: "Menu Items",
                                 type: "Link",
                                 link_type: "Entry",
                                 validations: [validation_link_content_type])
      ### Save and Publish
      content_type.save
      content_type.publish
    end
  end
end
