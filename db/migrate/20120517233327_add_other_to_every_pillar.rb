class AddOtherToEveryPillar < ActiveRecord::Migration
  def change    
    pillar_category = PillarCategory.find_by_name("Travel")
    other = pillar_category.event_types.create!(name: 'travel_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
    pillar_category = PillarCategory.find_by_name("Sports / Sports Fan")
    other = pillar_category.event_types.create!(name: 'sports_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
    pillar_category = PillarCategory.find_by_name("Reading / Writing / Art")
    other = pillar_category.event_types.create!(name: 'reading_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
    pillar_category = PillarCategory.find_by_name("Movies / TV")
    other = pillar_category.event_types.create!(name: 'movies_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
    pillar_category = PillarCategory.find_by_name("Charity / Volunteering")
    other = pillar_category.event_types.create!(name: 'charity_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
    pillar_category = PillarCategory.find_by_name("Education / Career")
    other = pillar_category.event_types.create!(name: 'education_other', has_attachments: true)
    other.event_descriptors.create!(field_type: :date, name: 'date')
    other.event_descriptors.create!(field_type: :text, name: 'describe_it')
    
  end
end
