class AddEventForICreated < ActiveRecord::Migration
  def up
    pillar_category = PillarCategory.find_by_name("Music / Dancing / Nightlife")
    event_type = pillar_category.event_types.create!(name: 'i_created', has_attachments: true)
    event_type.event_descriptors.create!(field_type: :string, name: 'what')
    event_type.event_descriptors.create!(field_type: :text, name: 'thoughts')
  end

  def down
  end
end
