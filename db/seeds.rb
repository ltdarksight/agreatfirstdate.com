# ActiveRecord::Base.establish_connection
# config = ActiveRecord::Base.configurations[Rails.env]
# ActiveRecord::Base.connection.tables.each do |table|
#   unless %w[schema_migrations].include? table
#     case config["adapter"]
#       when "mysql", "postgresql"
#         ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
#       when "sqlite", "sqlite3"
#         ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
#         ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
#         ActiveRecord::Base.connection.execute("VACUUM")
#     end
#   end
# end



TRAVEL = PillarCategory.create!(name: "Travel", description: "I get around. Whether that's trips to the city, the wild or places where English isn't ever spoken.", image: 'travel.png')
WHERE_DID_YOU_GO = TRAVEL.event_types.create!(name: 'where_did_you_go', has_attachments: true)
WHERE_DID_YOU_GO.event_descriptors.create!(field_type: :string, name: 'where_did_you_go')
WHERE_DID_YOU_GO.event_descriptors.create!(field_type: :date, name: 'when_did_you_go')
WHERE_DID_YOU_GO.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_TRAVEL_SPOTS = TRAVEL.event_types.create!(name: 'top_travel_spots', has_attachments: false)
TOP_TRAVEL_SPOTS.event_descriptors.create!(field_type: :text, name: 'list_them')

PRIVATE_JET = TRAVEL.event_types.create!(name: 'private_jet', has_attachments: false)
PRIVATE_JET.event_descriptors.create!(field_type: :text, name: 'i_would_be_off_to')

DREAM_VACATION = TRAVEL.event_types.create!(name: 'dream_vacation', has_attachments: false)
DREAM_VACATION.event_descriptors.create!(field_type: :string, name: "where")
DREAM_VACATION.event_descriptors.create!(field_type: :text, name: "text")

FAITH = PillarCategory.create!(name: "Faith / Religion / Spirituality", description: "The soul is important to me. Either I go to Church or I meditate.", image: 'faith.png')
I_WENT_TO_CHURCH = FAITH.event_types.create!(name: 'i_went_to_church', has_attachments: true)
I_WENT_TO_CHURCH.event_descriptors.create!(field_type: :string, name: 'which_one')
I_WENT_TO_CHURCH.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_CHURCH.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_MEDITATED = FAITH.event_types.create!(name: 'i_meditated', has_attachments: true)
I_MEDITATED.event_descriptors.create!(field_type: :date, name: 'date')
I_MEDITATED.event_descriptors.create!(field_type: :text, name: 'thoughts')

DESCRIBE_FAITH = FAITH.event_types.create!(name: 'describe_faith', has_attachments: false)
DESCRIBE_FAITH.event_descriptors.create!(field_type: :text, name: "text")

FAITH_OTHER = FAITH.event_types.create!(name: 'faith_other', has_attachments: true)
FAITH_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FAITH_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

HEALTH = PillarCategory.create!(name: "Health / Fitness", description: "I work out! I train, I play and I love an elevated heartbeat.", image: 'health.png')
I_WORKED_OUT = HEALTH.event_types.create!(name: 'i_worked_out', has_attachments: true)
I_WORKED_OUT.event_descriptors.create!(field_type: :string, name: 'where')
I_WORKED_OUT.event_descriptors.create!(field_type: :date, name: 'date')
I_WORKED_OUT.event_descriptors.create!(field_type: :text, name: 'what_did_you_do')

I_TOOK_UP_NEW = HEALTH.event_types.create!(name: 'i_took_up_new', has_attachments: true)
I_TOOK_UP_NEW.event_descriptors.create!(field_type: :date, name: 'date')
I_TOOK_UP_NEW.event_descriptors.create!(field_type: :text, name: 'what_is_it')

I_PLAYED = HEALTH.event_types.create!(name: 'i_played', has_attachments: true)
I_PLAYED.event_descriptors.create!(field_type: :string, name: 'which_stadium')
I_PLAYED.event_descriptors.create!(field_type: :date, name: 'date')
I_PLAYED.event_descriptors.create!(field_type: :text, name: 'what_was_it')

HEALTH_OTHER = HEALTH.event_types.create!(name: 'health_other', has_attachments: true)
HEALTH_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
HEALTH_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

SPORT = PillarCategory.create!(name: "Sports / Sports Fan", description: "I am a fan. Don't bother me on game, and you're dam right. I'll be wearing my favorite team's jersey.", image: 'sports.png')
FAVORITE_TEAM = SPORT.event_types.create!(name: 'favorite_team', has_attachments: false)
FAVORITE_TEAM.event_descriptors.create!(field_type: :string, name: 'who')
FAVORITE_TEAM.event_descriptors.create!(field_type: :string, name: 'how_long')

I_WENT_TO_A_GAME = SPORT.event_types.create!(name: 'i_went_to_a_game', has_attachments: true)
I_WENT_TO_A_GAME.event_descriptors.create!(field_type: :string, name: 'where')
I_WENT_TO_A_GAME.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_GAME.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_WATCHED_TO_A_GAME = SPORT.event_types.create!(name: 'i_watched_to_a_game', has_attachments: false)
I_WATCHED_TO_A_GAME.event_descriptors.create!(field_type: :date, name: 'date')
I_WATCHED_TO_A_GAME.event_descriptors.create!(field_type: :text, name: 'thoughts')

FASHION = PillarCategory.create!(name: "Fashion / Modeling", description: "I shop. I have style. I like to look good, and I want someone who appreciates it.", image: 'fashion.png')
WARDROBE_UPGRADE = FASHION.event_types.create!(name: 'wardrobe_upgrade', has_attachments: true)
WARDROBE_UPGRADE.event_descriptors.create!(field_type: :string, name: 'which_shop')
WARDROBE_UPGRADE.event_descriptors.create!(field_type: :date, name: 'date')
WARDROBE_UPGRADE.event_descriptors.create!(field_type: :text, name: 'thoughts')

WENT_TO_A_SHOW = FASHION.event_types.create!(name: 'went_to_a_show', has_attachments: true)
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :string, name: 'where')
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :date, name: 'date')
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_LOOK_BEST_IN = FASHION.event_types.create!(name: 'i_look_best_in', has_attachments: true)
I_LOOK_BEST_IN.event_descriptors.create!(field_type: :text, name: "text")

FASHION_OTHER = FASHION.event_types.create!(name: 'fashion_other', has_attachments: true)
FASHION_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FASHION_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

EAT_DRINK = PillarCategory.create!(name: "Eat / Drink", description: "", image: 'food.png')
I_WENT_OUT = EAT_DRINK.event_types.create!(name: 'i_went_out', has_attachments: true)
I_WENT_OUT.event_descriptors.create!(field_type: :string, name: 'where')
I_WENT_OUT.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_COOKED = EAT_DRINK.event_types.create!(name: 'i_cooked', has_attachments: true)
I_COOKED.event_descriptors.create!(field_type: :date, name: 'date')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'what_was_it')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'how_was_it')

TOP_RESTAURANTS = EAT_DRINK.event_types.create!(name: 'top_restaurants', has_attachments: false)
TOP_RESTAURANTS.event_descriptors.create!(field_type: :text, name: 'list_them')

MY_FAVORITE_FOOD = EAT_DRINK.event_types.create!(name: 'my_favorite_food', has_attachments: false)
MY_FAVORITE_FOOD.event_descriptors.create!(field_type: :text, name: "text")

MY_FAVORITE_DRINKS = EAT_DRINK.event_types.create!(name: 'my_favorite_drinks', has_attachments: false)
MY_FAVORITE_DRINKS.event_descriptors.create!(field_type: :text, name: "text")

EAT_DRINK_OTHER = EAT_DRINK.event_types.create!(name: 'eat_other', has_attachments: true)
EAT_DRINK_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
EAT_DRINK_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

ART = PillarCategory.create!(name: "Reading / Writing / Art", description: "Give me a good book, a pen, a museum and a few hours and I've my batteries fully recharged.", image: 'reading.png')
READING = ART.event_types.create!(name: 'reading', has_attachments: false)
READING.event_descriptors.create!(field_type: :text, name: "text")
READING.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_WROTE = ART.event_types.create!(name: 'i_wrote', has_attachments: false)
I_WROTE.event_descriptors.create!(field_type: :text, name: 'what_was_it')
I_WROTE.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_BOOKS = ART.event_types.create!(name: 'top_books', has_attachments: false)
TOP_BOOKS.event_descriptors.create!(field_type: :text, name: 'list_them')

I_CREATED = ART.event_types.create!(name: 'i_created', has_attachments: true)
I_CREATED.event_descriptors.create!(field_type: :text, name: "text")
I_CREATED.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_ARTISTS = ART.event_types.create!(name: 'top_artists', has_attachments: false)
TOP_ARTISTS.event_descriptors.create!(field_type: :text, name: 'list_them')

I_WENT_TO_A_MUSEUM = ART.event_types.create!(name: 'i_went_to_a_museum', has_attachments: true)
I_WENT_TO_A_MUSEUM.event_descriptors.create!(field_type: :string, name: 'which_museum')
I_WENT_TO_A_MUSEUM.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_MUSEUM.event_descriptors.create!(field_type: :text, name: 'thoughts')

MUSIC = PillarCategory.create!(name: "Music / Dancing / Nightlife", description: "Concerts, clubs, or occasionally busting a move. My world is out there.", image: 'music.png')
I_WENT_OUT_DANCING = MUSIC.event_types.create!(name: 'i_went_out_dancing', has_attachments: true)
I_WENT_OUT_DANCING.event_descriptors.create!(field_type: :string, name: 'which_club')
I_WENT_OUT_DANCING.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT_DANCING.event_descriptors.create!(field_type: :text, name: 'thoughts')

LISTENING_TO = MUSIC.event_types.create!(name: 'listening_To', has_attachments: false)
LISTENING_TO.event_descriptors.create!(field_type: :text, name: "text")
LISTENING_TO.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_WENT_TO_A_CONCERT = MUSIC.event_types.create!(name: 'i_went_to_a_concert', has_attachments: true)
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :string, name: 'where')
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :text, name: 'who')
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_MUSIC_ARTISTS = MUSIC.event_types.create!(name: 'top_music_artists', has_attachments: false)
TOP_MUSIC_ARTISTS.event_descriptors.create!(field_type: :text, name: 'list_them')

MUSIC_OTHER = MUSIC.event_types.create!(name: 'music_other', has_attachments: true)
MUSIC_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
MUSIC_OTHER.event_descriptors.create!(field_type: :text, name: 'what_is_it')
MUSIC_OTHER.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_WENT_OUT_MUSIC = MUSIC.event_types.create!(name: 'i_went_out_music', has_attachments: true)
I_WENT_OUT_MUSIC.event_descriptors.create!(field_type: :string, name: 'which_club_bar')
I_WENT_OUT_MUSIC.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT_MUSIC.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_SPOTS = MUSIC.event_types.create!(name: 'top_spots', has_attachments: false)
TOP_SPOTS.event_descriptors.create!(field_type: :text, name: 'list_them')

MOVIES = PillarCategory.create!(name: "Movies / TV", description: "Give me story, give me laughter, give me plots twists!", image: 'movies.png')
I_WATCHED_SOMETHING = MOVIES.event_types.create!(name: 'i_watched_something', has_attachments: false)
I_WATCHED_SOMETHING.event_descriptors.create!(field_type: :date, name: 'date')
I_WATCHED_SOMETHING.event_descriptors.create!(field_type: :string, name: 'what_was_it')
I_WATCHED_SOMETHING.event_descriptors.create!(field_type: :text, name: 'thoughts')

TOP_TV = MOVIES.event_types.create!(name: 'top_tv', has_attachments: false)
TOP_TV.event_descriptors.create!(field_type: :text, name: 'list_them')

TOP_MOVIES = MOVIES.event_types.create!(name: 'top_movies', has_attachments: false)
TOP_MOVIES.event_descriptors.create!(field_type: :text, name: 'list_them')

I_WENT_TO_MOVIES = MOVIES.event_types.create!(name: 'i_went_to_movies', has_attachments: true)
I_WENT_TO_MOVIES.event_descriptors.create!(field_type: :text, name: 'what_did_you_see')
I_WENT_TO_MOVIES.event_descriptors.create!(field_type: :text, name: 'thoughts')

FAMILY = PillarCategory.create!(name: "Family", description: "Need I say more? Love 'em or hate 'em I can't imagine life without 'em.", image: 'family.png')
MY_FAMILY = FAMILY.event_types.create!(name: 'my_family', has_attachments: false)
MY_FAMILY.event_descriptors.create!(field_type: :text, name: "text")

KICKED_IT_WITH_THE_FAM = FAMILY.event_types.create!(name: 'kicked_it_with_the_fam', has_attachments: true)
KICKED_IT_WITH_THE_FAM.event_descriptors.create!(field_type: :date, name: 'date')
KICKED_IT_WITH_THE_FAM.event_descriptors.create!(field_type: :text, name: 'thoughts')

PETS_ARE_FAMILY_TOO = FAMILY.event_types.create!(name: 'pets_are_family_too', has_attachments: true)
PETS_ARE_FAMILY_TOO.event_descriptors.create!(field_type: :string, name: 'name')
PETS_ARE_FAMILY_TOO.event_descriptors.create!(field_type: :text, name: 'tell_us_about_them')

FAMILY_OTHER = FAMILY.event_types.create!(name: 'family_other', has_attachments: true)
FAMILY_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FAMILY_OTHER.event_descriptors.create!(field_type: :text, name: 'thoughts')

CHARITY = PillarCategory.create!(name: "Charity / Volunteering", description: "I give back. I believe in, and participate in good causese every chance I get.", image: 'charity.png')
I_VOLUNTEERED = CHARITY.event_types.create!(name: 'i_volunteered', has_attachments: true)
I_VOLUNTEERED.event_descriptors.create!(field_type: :string, name: 'where_voluntereed')
I_VOLUNTEERED.event_descriptors.create!(field_type: :date, name: 'date')
I_VOLUNTEERED.event_descriptors.create!(field_type: :text, name: 'thoughts')

MY_CAUSES = CHARITY.event_types.create!(name: 'my_causes', has_attachments: false)
MY_CAUSES.event_descriptors.create!(field_type: :text, name: 'list_them')

I_GAVE_TO_CHARITY = CHARITY.event_types.create!(name: 'i_gave_to_charity', has_attachments: false)
I_GAVE_TO_CHARITY.event_descriptors.create!(field_type: :date, name: 'date')
I_GAVE_TO_CHARITY.event_descriptors.create!(field_type: :text, name: 'thoughts')

EDUCATION = PillarCategory.create!(name: "Education / Career", description: "I'm educated, and I still wear my sweatshirt from the U. Or, I'm proud of what I do and I work hard at it.", image: 'education.png')
I_STUDIED_AT = EDUCATION.event_types.create!(name: 'i_studied_at', has_attachments: true)
I_STUDIED_AT.event_descriptors.create!(field_type: :string, name: 'where')
I_STUDIED_AT.event_descriptors.create!(field_type: :string, name: 'when')
I_STUDIED_AT.event_descriptors.create!(field_type: :text, name: 'thoughts')

I_WENT_TO_CLASS = EDUCATION.event_types.create!(name: 'i_went_to_class', has_attachments: true)
I_WENT_TO_CLASS.event_descriptors.create!(field_type: :string, name: 'where_class')
I_WENT_TO_CLASS.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_CLASS.event_descriptors.create!(field_type: :text, name: 'thoughts')

WORKING_HARD = EDUCATION.event_types.create!(name: 'working_hard', has_attachments: false)
WORKING_HARD.event_descriptors.create!(field_type: :string, name: 'where_working')
WORKING_HARD.event_descriptors.create!(field_type: :text, name: 'doing')
WORKING_HARD.event_descriptors.create!(field_type: :text, name: 'thoughts')

WHAT_I_DO = EDUCATION.event_types.create!(name: 'what_i_do', has_attachments: false)
WHAT_I_DO.event_descriptors.create!(field_type: :text, name: "text")
WHAT_I_DO.event_descriptors.create!(field_type: :text, name: 'thoughts')

# def category_ids
#   (1..4).map { rand(TRAVEL.id..EDUCATION.id) }.uniq
# end
# 
# man = User.create!(email: 'man@rubybakers.com', password: 123456)
# man.build_profile({
#   who_am_i: 'I am a man',
#   who_meet: 'woman',
#   first_name: 'John',
#   last_name: 'Smith',
#   gender: 'male',
#   looking_for: 'female',
#   customer_status: true,
#   customer_subscription_status: true,
#   invoice_status: true,
#   stripe_customer_token: "cus_2oJ1VxnQm4NxZe",
#   pillar_category_ids: category_ids,
#   age: 28,
#   in_or_around: 'Denver, CO'
# }).save!
# man.update_attribute(:role, 'admin')
# 
# avatar = Avatar.create!(:profile => man.profile)
# avatar.image.store!(File.open(File.join(Rails.root, 'test/fixtures/photo.jpg')))
# avatar.save!
# 
# man.confirmed_at = Time.zone.now
# man.save
# 
# 20.times do
#   f = Factory.create :male, pillar_category_ids: category_ids,
#                  first_name: Faker::Name.first_name,
#                  last_name: Faker::Name.last_name,
#                  who_am_i: Faker::Lorem.paragraph(5),
#                  who_meet: Faker::Lorem.paragraph(5),
#                  in_or_around: 'Denver, CO'
#   avatar = Avatar.create!(:profile => f)
#   avatar.image.store!(File.open(File.join(Rails.root, 'test/fixtures/photo.jpg')))
#   avatar.save!
# end
# 
# 70.times do
#   f = Factory.create :female, pillar_category_ids: category_ids,
#                  first_name: Faker::Name.first_name,
#                  last_name: Faker::Name.last_name,
#                  who_am_i: Faker::Lorem.paragraph(5),
#                  who_meet: Faker::Lorem.paragraph(5),
#                  in_or_around: 'Denver, CO'
#   avatar = Avatar.create!(:profile => f)
#   avatar.image.store!(File.open(File.join(Rails.root, 'test/fixtures/photo.jpg')))
#   avatar.save!
# end
