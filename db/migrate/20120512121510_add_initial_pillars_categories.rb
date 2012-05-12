class AddInitialPillarsCategories < ActiveRecord::Migration
  def change
    travel = PillarCategory.create!(name: "Travel", description: "I get around. Whether that's trips to the city, the wild or places where English isn't ever spoken.", image: 'travel.png')
    where_did_you_go = travel.event_types.create!(name: 'where_did_you_go', has_attachments: true)
    where_did_you_go.event_descriptors.create!(field_type: :string, name: 'where_did_you_go')
    where_did_you_go.event_descriptors.create!(field_type: :date, name: 'when_did_you_go')
    where_did_you_go.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_travel_spots = travel.event_types.create!(name: 'top_travel_spots', has_attachments: false)
    top_travel_spots.event_descriptors.create!(field_type: :text, name: 'list_them')

    private_jet = travel.event_types.create!(name: 'private_jet', has_attachments: false)
    private_jet.event_descriptors.create!(field_type: :text, name: 'i_would_be_off_to')

    dream_vacation = travel.event_types.create!(name: 'dream_vacation', has_attachments: false)
    dream_vacation.event_descriptors.create!(field_type: :string, name: "where")
    dream_vacation.event_descriptors.create!(field_type: :text, name: "text")

    faith = PillarCategory.create!(name: "Faith / Religion / Spirituality", description: "The soul is important to me. Either I go to Church or I meditate.", image: 'faith.png')
    i_went_to_church = faith.event_types.create!(name: 'i_went_to_church', has_attachments: true)
    i_went_to_church.event_descriptors.create!(field_type: :string, name: 'which_one')
    i_went_to_church.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_to_church.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_meditated = faith.event_types.create!(name: 'i_meditated', has_attachments: true)
    i_meditated.event_descriptors.create!(field_type: :date, name: 'date')
    i_meditated.event_descriptors.create!(field_type: :text, name: 'thoughts')

    describe_faith = faith.event_types.create!(name: 'describe_faith', has_attachments: false)
    describe_faith.event_descriptors.create!(field_type: :text, name: "text")

    faith_other = faith.event_types.create!(name: 'faith_other', has_attachments: true)
    faith_other.event_descriptors.create!(field_type: :date, name: 'date')
    faith_other.event_descriptors.create!(field_type: :text, name: 'describe_it')

    health = PillarCategory.create!(name: "Health / Fitness", description: "I work out! I train, I play and I love an elevated heartbeat.", image: 'health.png')
    i_worked_out = health.event_types.create!(name: 'i_worked_out', has_attachments: true)
    i_worked_out.event_descriptors.create!(field_type: :string, name: 'where')
    i_worked_out.event_descriptors.create!(field_type: :date, name: 'date')
    i_worked_out.event_descriptors.create!(field_type: :text, name: 'what_did_you_do')

    i_took_up_new = health.event_types.create!(name: 'i_took_up_new', has_attachments: true)
    i_took_up_new.event_descriptors.create!(field_type: :date, name: 'date')
    i_took_up_new.event_descriptors.create!(field_type: :text, name: 'what_is_it')

    i_played = health.event_types.create!(name: 'i_played', has_attachments: true)
    i_played.event_descriptors.create!(field_type: :string, name: 'which_stadium')
    i_played.event_descriptors.create!(field_type: :date, name: 'date')
    i_played.event_descriptors.create!(field_type: :text, name: 'what_was_it')

    health_other = health.event_types.create!(name: 'health_other', has_attachments: true)
    health_other.event_descriptors.create!(field_type: :date, name: 'date')
    health_other.event_descriptors.create!(field_type: :text, name: 'describe_it')

    sport = PillarCategory.create!(name: "Sports / Sports Fan", description: "I am a fan. Don't bother me on game, and you're dam right. I'll be wearing my favorite team's jersey.", image: 'sports.png')
    favorite_team = sport.event_types.create!(name: 'favorite_team', has_attachments: false)
    favorite_team.event_descriptors.create!(field_type: :string, name: 'who')
    favorite_team.event_descriptors.create!(field_type: :string, name: 'how_long')

    i_went_to_a_game = sport.event_types.create!(name: 'i_went_to_a_game', has_attachments: true)
    i_went_to_a_game.event_descriptors.create!(field_type: :string, name: 'where')
    i_went_to_a_game.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_to_a_game.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_watched_to_a_game = sport.event_types.create!(name: 'i_watched_to_a_game', has_attachments: false)
    i_watched_to_a_game.event_descriptors.create!(field_type: :date, name: 'date')
    i_watched_to_a_game.event_descriptors.create!(field_type: :text, name: 'thoughts')

    fashion = PillarCategory.create!(name: "Fashion / Modeling", description: "I shop. I have style. I like to look good, and I want someone who appreciates it.", image: 'fashion.png')
    wardrobe_upgrade = fashion.event_types.create!(name: 'wardrobe_upgrade', has_attachments: true)
    wardrobe_upgrade.event_descriptors.create!(field_type: :string, name: 'which_shop')
    wardrobe_upgrade.event_descriptors.create!(field_type: :date, name: 'date')
    wardrobe_upgrade.event_descriptors.create!(field_type: :text, name: 'thoughts')

    went_to_a_show = fashion.event_types.create!(name: 'went_to_a_show', has_attachments: true)
    went_to_a_show.event_descriptors.create!(field_type: :string, name: 'where')
    went_to_a_show.event_descriptors.create!(field_type: :date, name: 'date')
    went_to_a_show.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_look_best_in = fashion.event_types.create!(name: 'i_look_best_in', has_attachments: true)
    i_look_best_in.event_descriptors.create!(field_type: :text, name: "text")

    fashion_other = fashion.event_types.create!(name: 'fashion_other', has_attachments: true)
    fashion_other.event_descriptors.create!(field_type: :date, name: 'date')
    fashion_other.event_descriptors.create!(field_type: :text, name: 'describe_it')

    eat_drink = PillarCategory.create!(name: "Eat / Drink", description: "", image: 'food.png')
    i_went_out = eat_drink.event_types.create!(name: 'i_went_out', has_attachments: true)
    i_went_out.event_descriptors.create!(field_type: :string, name: 'where')
    i_went_out.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_out.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_cooked = eat_drink.event_types.create!(name: 'i_cooked', has_attachments: true)
    i_cooked.event_descriptors.create!(field_type: :date, name: 'date')
    i_cooked.event_descriptors.create!(field_type: :text, name: 'what_was_it')
    i_cooked.event_descriptors.create!(field_type: :text, name: 'how_was_it')

    top_restaurants = eat_drink.event_types.create!(name: 'top_restaurants', has_attachments: false)
    top_restaurants.event_descriptors.create!(field_type: :text, name: 'list_them')

    my_favorite_food = eat_drink.event_types.create!(name: 'my_favorite_food', has_attachments: false)
    my_favorite_food.event_descriptors.create!(field_type: :text, name: "text")

    my_favorite_drinks = eat_drink.event_types.create!(name: 'my_favorite_drinks', has_attachments: false)
    my_favorite_drinks.event_descriptors.create!(field_type: :text, name: "text")

    eat_drink_other = eat_drink.event_types.create!(name: 'eat_other', has_attachments: true)
    eat_drink_other.event_descriptors.create!(field_type: :date, name: 'date')
    eat_drink_other.event_descriptors.create!(field_type: :text, name: 'describe_it')

    art = PillarCategory.create!(name: "Reading / Writing / Art", description: "Give me a good book, a pen, a museum and a few hours and I've my batteries fully recharged.", image: 'reading.png')
    reading = art.event_types.create!(name: 'reading', has_attachments: false)
    reading.event_descriptors.create!(field_type: :text, name: "text")
    reading.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_wrote = art.event_types.create!(name: 'i_wrote', has_attachments: false)
    i_wrote.event_descriptors.create!(field_type: :text, name: 'what_was_it')
    i_wrote.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_books = art.event_types.create!(name: 'top_books', has_attachments: false)
    top_books.event_descriptors.create!(field_type: :text, name: 'list_them')

    i_created = art.event_types.create!(name: 'i_created', has_attachments: true)
    i_created.event_descriptors.create!(field_type: :text, name: "text")
    i_created.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_artists = art.event_types.create!(name: 'top_artists', has_attachments: false)
    top_artists.event_descriptors.create!(field_type: :text, name: 'list_them')

    i_went_to_a_museum = art.event_types.create!(name: 'i_went_to_a_museum', has_attachments: true)
    i_went_to_a_museum.event_descriptors.create!(field_type: :string, name: 'which_museum')
    i_went_to_a_museum.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_to_a_museum.event_descriptors.create!(field_type: :text, name: 'thoughts')

    music = PillarCategory.create!(name: "Music / Dancing / Nightlife", description: "Concerts, clubs, or occasionally busting a move. My world is out there.", image: 'music.png')
    i_went_out_dancing = music.event_types.create!(name: 'i_went_out_dancing', has_attachments: true)
    i_went_out_dancing.event_descriptors.create!(field_type: :string, name: 'which_club')
    i_went_out_dancing.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_out_dancing.event_descriptors.create!(field_type: :text, name: 'thoughts')

    listening_to = music.event_types.create!(name: 'listening_To', has_attachments: false)
    listening_to.event_descriptors.create!(field_type: :text, name: "text")
    listening_to.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_went_to_a_concert = music.event_types.create!(name: 'i_went_to_a_concert', has_attachments: true)
    i_went_to_a_concert.event_descriptors.create!(field_type: :string, name: 'where')
    i_went_to_a_concert.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_to_a_concert.event_descriptors.create!(field_type: :text, name: 'who')
    i_went_to_a_concert.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_music_artists = music.event_types.create!(name: 'top_music_artists', has_attachments: false)
    top_music_artists.event_descriptors.create!(field_type: :text, name: 'list_them')

    music_other = music.event_types.create!(name: 'music_other', has_attachments: true)
    music_other.event_descriptors.create!(field_type: :date, name: 'date')
    music_other.event_descriptors.create!(field_type: :text, name: 'what_is_it')
    music_other.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_went_out_music = music.event_types.create!(name: 'i_went_out_music', has_attachments: true)
    i_went_out_music.event_descriptors.create!(field_type: :string, name: 'which_club_bar')
    i_went_out_music.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_out_music.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_spots = music.event_types.create!(name: 'top_spots', has_attachments: false)
    top_spots.event_descriptors.create!(field_type: :text, name: 'list_them')

    movies = PillarCategory.create!(name: "Movies / TV", description: "Give me story, give me laughter, give me plots twists!", image: 'movies.png')
    i_watched_something = movies.event_types.create!(name: 'i_watched_something', has_attachments: false)
    i_watched_something.event_descriptors.create!(field_type: :date, name: 'date')
    i_watched_something.event_descriptors.create!(field_type: :string, name: 'what_was_it')
    i_watched_something.event_descriptors.create!(field_type: :text, name: 'thoughts')

    top_tv = movies.event_types.create!(name: 'top_tv', has_attachments: false)
    top_tv.event_descriptors.create!(field_type: :text, name: 'list_them')

    top_movies = movies.event_types.create!(name: 'top_movies', has_attachments: false)
    top_movies.event_descriptors.create!(field_type: :text, name: 'list_them')

    i_went_to_movies = movies.event_types.create!(name: 'i_went_to_movies', has_attachments: true)
    i_went_to_movies.event_descriptors.create!(field_type: :text, name: 'what_did_you_see')
    i_went_to_movies.event_descriptors.create!(field_type: :text, name: 'thoughts')

    family = PillarCategory.create!(name: "Family", description: "Need I say more? Love 'em or hate 'em I can't imagine life without 'em.", image: 'family.png')
    my_family = family.event_types.create!(name: 'my_family', has_attachments: false)
    my_family.event_descriptors.create!(field_type: :text, name: "text")

    kicked_it_with_the_fam = family.event_types.create!(name: 'kicked_it_with_the_fam', has_attachments: true)
    kicked_it_with_the_fam.event_descriptors.create!(field_type: :date, name: 'date')
    kicked_it_with_the_fam.event_descriptors.create!(field_type: :text, name: 'thoughts')

    pets_are_family_too = family.event_types.create!(name: 'pets_are_family_too', has_attachments: true)
    pets_are_family_too.event_descriptors.create!(field_type: :string, name: 'name')
    pets_are_family_too.event_descriptors.create!(field_type: :text, name: 'tell_us_about_them')

    family_other = family.event_types.create!(name: 'family_other', has_attachments: true)
    family_other.event_descriptors.create!(field_type: :date, name: 'date')
    family_other.event_descriptors.create!(field_type: :text, name: 'thoughts')

    charity = PillarCategory.create!(name: "Charity / Volunteering", description: "I give back. I believe in, and participate in good causese every chance I get.", image: 'charity.png')
    i_volunteered = charity.event_types.create!(name: 'i_volunteered', has_attachments: true)
    i_volunteered.event_descriptors.create!(field_type: :string, name: 'where_voluntereed')
    i_volunteered.event_descriptors.create!(field_type: :date, name: 'date')
    i_volunteered.event_descriptors.create!(field_type: :text, name: 'thoughts')

    my_causes = charity.event_types.create!(name: 'my_causes', has_attachments: false)
    my_causes.event_descriptors.create!(field_type: :text, name: 'list_them')

    i_gave_to_charity = charity.event_types.create!(name: 'i_gave_to_charity', has_attachments: false)
    i_gave_to_charity.event_descriptors.create!(field_type: :date, name: 'date')
    i_gave_to_charity.event_descriptors.create!(field_type: :text, name: 'thoughts')

    education = PillarCategory.create!(name: "Education / Career", description: "I'm educated, and I still wear my sweatshirt from the U. Or, I'm proud of what I do and I work hard at it.", image: 'education.png')
    i_studied_at = education.event_types.create!(name: 'i_studied_at', has_attachments: true)
    i_studied_at.event_descriptors.create!(field_type: :string, name: 'where')
    i_studied_at.event_descriptors.create!(field_type: :string, name: 'when')
    i_studied_at.event_descriptors.create!(field_type: :text, name: 'thoughts')

    i_went_to_class = education.event_types.create!(name: 'i_went_to_class', has_attachments: true)
    i_went_to_class.event_descriptors.create!(field_type: :string, name: 'where_class')
    i_went_to_class.event_descriptors.create!(field_type: :date, name: 'date')
    i_went_to_class.event_descriptors.create!(field_type: :text, name: 'thoughts')

    working_hard = education.event_types.create!(name: 'working_hard', has_attachments: false)
    working_hard.event_descriptors.create!(field_type: :string, name: 'where_working')
    working_hard.event_descriptors.create!(field_type: :text, name: 'doing')
    working_hard.event_descriptors.create!(field_type: :text, name: 'thoughts')

    what_i_do = education.event_types.create!(name: 'what_i_do', has_attachments: false)
    what_i_do.event_descriptors.create!(field_type: :text, name: "text")
    what_i_do.event_descriptors.create!(field_type: :text, name: 'thoughts')
  end
end
