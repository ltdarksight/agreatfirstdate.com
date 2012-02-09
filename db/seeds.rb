# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# MySQL
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}") unless %w[schema_migrations pillar_categories].include? table
end

man = User.create!(email: 'man@23ninja.com', password: 123456)
man.build_profile({
                  who_am_i: 'I am a man',
                  first_name: 'John',
                  last_name: 'Smith',
                  age: 33
                  }).save!

TRAVEL = PillarCategory.find(6)
WHERE_WOULD_YOU_GO = TRAVEL.event_types.create!(name: 'where_would_you_go', has_attachments: true)
WHERE_WOULD_YOU_GO.event_descriptors.create!(field_type: :date, name: 'when_did_you_go')
WHERE_WOULD_YOU_GO.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_TRAVEL_SPOTS = TRAVEL.event_types.create!(name: 'top_travel_spots', has_attachments: false)
TOP_TRAVEL_SPOTS.event_descriptors.create!(field_type: :text, name: 'list_them')

PRIVATE_JET = TRAVEL.event_types.create!(name: 'private_jet', has_attachments: false)
PRIVATE_JET.event_descriptors.create!(field_type: :text, name: 'i_would_be_off_to')

DREAM_VACATION = TRAVEL.event_types.create!(name: 'dream_vacation', has_attachments: false)
DREAM_VACATION.event_descriptors.create!(field_type: :text, name: nil)


EAT_DRINK = PillarCategory.find(4)
I_COOKED = EAT_DRINK.event_types.create!(name: 'i_cooked', has_attachments: true)
I_COOKED.event_descriptors.create!(field_type: :date, name: 'date')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'what_was_it')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'how_was_it')
