# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# MySQL
ActiveRecord::Base.establish_connection
config = ActiveRecord::Base.configurations[Rails.env]
ActiveRecord::Base.connection.tables.each do |table|
  unless %w[schema_migrations pillar_categories].include? table
    case config["adapter"]
      when "mysql", "postgresql"
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      when "sqlite", "sqlite3"
        ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
        ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
        ActiveRecord::Base.connection.execute("VACUUM")
    end
  end
end

[
  ["Health / Fitness","I work out! I train, I play and I love an elevated heartbeat."],
  ["Faith / Religion / Spirituality","The soul is important to me. Either I go to Church or I meditate."],
  ["Sports / Sports Fan","I am a fan. Don't bother me on game, and you're dam right. I'll be wearing my favorite team's jersey."],
  ["Eat / Drink",""],

  ["Charity / Volunteering","I give back. I believe in, and participate in good causese every chance I get."],
  ["Travel","I get around. Whether that's trips to the city, the wild or places where English isn't ever spoken."],
  ["Education / Career","I'm educated, and I still wear my sweatshirt from the U. Or, I'm proud of what I do and I work hard at it."],
  ["Fashion / Modeling","I shop. I have style. I like to look good, and I want someone who appreciates it."],

  ["Family","Need I say more? Love 'em or hate 'em I can't imagine life without 'em."],
  ["Movies / TV","Give me story, give me laughter, give me plots twists!"],
  ["Music / Dancing / Nightlife","Concerts, clubs, or occasionally busting a move. My world is out there."],
  ["Reading / Writing / Art","Give me a good book, a pen, a museum and a few hours and I've my batteries fully recharged."]
].each do |category|
  PillarCategory.create :name => category[0], :description => category[1]  
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

FAITH = PillarCategory.find(2)
I_WENT_TO_CHURCH = FAITH.event_types.create!(name: 'i_went_to_church', has_attachments: true)
I_WENT_TO_CHURCH.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_CHURCH.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_MEDITATED = FAITH.event_types.create!(name: 'i_meditated', has_attachments: true)
I_MEDITATED.event_descriptors.create!(field_type: :date, name: 'date')
I_MEDITATED.event_descriptors.create!(field_type: :text, name: 'thoughts')
DESCRIBE_FAITH = FAITH.event_types.create!(name: 'describe_faith', has_attachments: false)
DESCRIBE_FAITH.event_descriptors.create!(field_type: :text, name: nil)
FAITH_OTHER = FAITH.event_types.create!(name: 'other', has_attachments: true)
FAITH_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FAITH_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

HEALTH = PillarCategory.find(1)
I_WORKED_OUT = HEALTH.event_types.create!(name: 'i_worked_out', has_attachments: true)
I_WORKED_OUT.event_descriptors.create!(field_type: :date, name: 'date')
I_WORKED_OUT.event_descriptors.create!(field_type: :text, name: 'what_did_you_do')
I_TOOK_UP_NEW = HEALTH.event_types.create!(name: 'i_took_up_new', has_attachments: true)
I_TOOK_UP_NEW.event_descriptors.create!(field_type: :date, name: 'date')
I_TOOK_UP_NEW.event_descriptors.create!(field_type: :text, name: 'what_is_it')
I_PLAYED = HEALTH.event_types.create!(name: 'i_played', has_attachments: true)
I_PLAYED.event_descriptors.create!(field_type: :date, name: 'date')
I_PLAYED.event_descriptors.create!(field_type: :text, name: 'what_was_it')
HEALTH_OTHER = HEALTH.event_types.create!(name: 'other', has_attachments: true)
HEALTH_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
HEALTH_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

SPORT = PillarCategory.find(3)
FAVORITE_TEAM = SPORT.event_types.create!(name: 'favorite_team', has_attachments: false)
FAVORITE_TEAM.event_descriptors.create!(field_type: :string, name: 'who')
FAVORITE_TEAM.event_descriptors.create!(field_type: :string, name: 'how_long')
I_WENT_TO_A_GAME = SPORT.event_types.create!(name: 'i_went_to_a_game', has_attachments: true)
I_WENT_TO_A_GAME.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_GAME.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_WATCHED_TO_A_GAME = SPORT.event_types.create!(name: 'i_watched_to_a_game', has_attachments: false)
I_WATCHED_TO_A_GAME.event_descriptors.create!(field_type: :date, name: 'date')
I_WATCHED_TO_A_GAME.event_descriptors.create!(field_type: :text, name: 'thoughts')

FASHION = PillarCategory.find(8)
WARDROBE_UPGRADE = FASHION.event_types.create!(name: 'wardrobe_upgrade', has_attachments: true)
WARDROBE_UPGRADE.event_descriptors.create!(field_type: :date, name: 'date')
WARDROBE_UPGRADE.event_descriptors.create!(field_type: :text, name: 'thoughts')
WENT_TO_A_SHOW = FASHION.event_types.create!(name: 'went_to_a_show', has_attachments: true)
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :date, name: 'date')
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_LOOK_BEST_IN = FASHION.event_types.create!(name: 'i_look_best_in', has_attachments: true)
WENT_TO_A_SHOW.event_descriptors.create!(field_type: :text, name: nil)
FASHION_OTHER = FASHION.event_types.create!(name: 'other', has_attachments: true)
FASHION_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FASHION_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

EAT_DRINK = PillarCategory.find(4)
I_WENT_OUT = EAT_DRINK.event_types.create!(name: 'i_went_out', has_attachments: true)
I_WENT_OUT.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_COOKED = EAT_DRINK.event_types.create!(name: 'i_cooked', has_attachments: true)
I_COOKED.event_descriptors.create!(field_type: :date, name: 'date')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'what_was_it')
I_COOKED.event_descriptors.create!(field_type: :text, name: 'how_was_it')
TOP_RESTAURANTS = EAT_DRINK.event_types.create!(name: 'top_restaurants', has_attachments: false)
TOP_RESTAURANTS.event_descriptors.create!(field_type: :text, name: 'list_them')
MY_FAVORITE_FOOD = EAT_DRINK.event_types.create!(name: 'my_favorite_food', has_attachments: false)
MY_FAVORITE_FOOD.event_descriptors.create!(field_type: :text, name: nil)
MY_FAVORITE_DRINKS = EAT_DRINK.event_types.create!(name: 'my_favorite_drinks', has_attachments: false)
MY_FAVORITE_DRINKS.event_descriptors.create!(field_type: :text, name: nil)
EAT_DRINK_OTHER = EAT_DRINK.event_types.create!(name: 'other', has_attachments: true)
EAT_DRINK_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
EAT_DRINK_OTHER.event_descriptors.create!(field_type: :text, name: 'describe_it')

ART = PillarCategory.find(12)
READING = ART.event_types.create!(name: 'reading', has_attachments: false)
READING.event_descriptors.create!(field_type: :text, name: nil)
READING.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_WROTE = ART.event_types.create!(name: 'i_wrote', has_attachments: false)
I_WROTE.event_descriptors.create!(field_type: :text, name: 'what_was_it')
I_WROTE.event_descriptors.create!(field_type: :text, name: 'thoughts')
TOP_BOOKS = ART.event_types.create!(name: 'top_books', has_attachments: false)
TOP_BOOKS.event_descriptors.create!(field_type: :text, name: 'list_them')
I_CREATED = ART.event_types.create!(name: 'i_created', has_attachments: true)
I_CREATED.event_descriptors.create!(field_type: :text, name: nil)
I_CREATED.event_descriptors.create!(field_type: :text, name: 'thoughts')
TOP_ARTISTS = ART.event_types.create!(name: 'top_artists', has_attachments: false)
TOP_ARTISTS.event_descriptors.create!(field_type: :text, name: 'list_them')
I_WENT_TO_A_MUSEUM = ART.event_types.create!(name: 'i_went_to_a_museum', has_attachments: true)
I_WENT_TO_A_MUSEUM.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_MUSEUM.event_descriptors.create!(field_type: :text, name: 'thoughts')

MUSIC = PillarCategory.find(11)
I_WENT_OUT_DANCING = MUSIC.event_types.create!(name: 'i_went_out_dancing', has_attachments: true)
I_WENT_OUT_DANCING.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT_DANCING.event_descriptors.create!(field_type: :text, name: 'thoughts')
LISTENING_TO = MUSIC.event_types.create!(name: 'listening_To', has_attachments: false)
LISTENING_TO.event_descriptors.create!(field_type: :text, name: nil)
LISTENING_TO.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_WENT_TO_A_CONCERT = MUSIC.event_types.create!(name: 'i_went_to_a_concert', has_attachments: true)
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :text, name: 'who')
I_WENT_TO_A_CONCERT.event_descriptors.create!(field_type: :text, name: 'thoughts')
TOP_MUSIC_ARTISTS = MUSIC.event_types.create!(name: 'top_music_artists', has_attachments: false)
TOP_MUSIC_ARTISTS.event_descriptors.create!(field_type: :text, name: 'list_them')
MUSIC_OTHER = MUSIC.event_types.create!(name: 'other', has_attachments: true)
MUSIC_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
MUSIC_OTHER.event_descriptors.create!(field_type: :text, name: 'who')
MUSIC_OTHER.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_WENT_OUT_MUSIC = MUSIC.event_types.create!(name: 'i_went_out_music', has_attachments: true)
I_WENT_OUT_MUSIC.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_OUT_MUSIC.event_descriptors.create!(field_type: :text, name: 'thoughts')
TOP_SPORTS = MUSIC.event_types.create!(name: 'top_sports', has_attachments: false)
TOP_SPORTS.event_descriptors.create!(field_type: :text, name: 'list_them')

MOVIES = PillarCategory.find(10)
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

FAMILY = PillarCategory.find(9)
MY_FAMILY = FAMILY.event_types.create!(name: 'my_family', has_attachments: false)
MY_FAMILY.event_descriptors.create!(field_type: :text, name: nil)
KICKED_IT_WITH_THE_FAM = FAMILY.event_types.create!(name: 'kicked_it_with_the_fam', has_attachments: true)
KICKED_IT_WITH_THE_FAM.event_descriptors.create!(field_type: :date, name: 'date')
KICKED_IT_WITH_THE_FAM.event_descriptors.create!(field_type: :text, name: 'thoughts')
PETS_ARE_FAMILY_TOO = FAMILY.event_types.create!(name: 'pets_are_family_too', has_attachments: true)
PETS_ARE_FAMILY_TOO.event_descriptors.create!(field_type: :string, name: 'name')
PETS_ARE_FAMILY_TOO.event_descriptors.create!(field_type: :text, name: 'tell_us_about_them')
FAMILY_OTHER = FAMILY.event_types.create!(name: 'family_other', has_attachments: true)
FAMILY_OTHER.event_descriptors.create!(field_type: :date, name: 'date')
FAMILY_OTHER.event_descriptors.create!(field_type: :text, name: 'thoughts')

CHARITY = PillarCategory.find(5)
I_VOLUNTEERED = CHARITY.event_types.create!(name: 'i_volunteered', has_attachments: true)
I_VOLUNTEERED.event_descriptors.create!(field_type: :date, name: 'date')
I_VOLUNTEERED.event_descriptors.create!(field_type: :text, name: 'thoughts')
MY_CAUSES = CHARITY.event_types.create!(name: 'my_causes', has_attachments: false)
MY_CAUSES.event_descriptors.create!(field_type: :text, name: 'list_them')
I_GAVE_TO_CHARITY = CHARITY.event_types.create!(name: 'i_gave_to_charity', has_attachments: false)
I_GAVE_TO_CHARITY.event_descriptors.create!(field_type: :date, name: 'date')
I_GAVE_TO_CHARITY.event_descriptors.create!(field_type: :text, name: 'thoughts')

EDUCATION = PillarCategory.find(7)
I_STUDIED_AT = EDUCATION.event_types.create!(name: 'i_studied_at', has_attachments: true)
I_STUDIED_AT.event_descriptors.create!(field_type: :string, name: 'where')
I_STUDIED_AT.event_descriptors.create!(field_type: :string, name: 'when')
I_STUDIED_AT.event_descriptors.create!(field_type: :text, name: 'thoughts')
I_WENT_TO_CLASS = EDUCATION.event_types.create!(name: 'i_went_to_class', has_attachments: true)
I_WENT_TO_CLASS.event_descriptors.create!(field_type: :date, name: 'date')
I_WENT_TO_CLASS.event_descriptors.create!(field_type: :text, name: 'thoughts')
WORKING_HARD = EDUCATION.event_types.create!(name: 'working_hard', has_attachments: false)
WORKING_HARD.event_descriptors.create!(field_type: :text, name: 'doing')
WORKING_HARD.event_descriptors.create!(field_type: :text, name: 'thoughts')
WHAT_I_DO = EDUCATION.event_types.create!(name: 'what_i_do', has_attachments: false)
WHAT_I_DO.event_descriptors.create!(field_type: :text, name: nil)
WHAT_I_DO.event_descriptors.create!(field_type: :text, name: 'thoughts')

