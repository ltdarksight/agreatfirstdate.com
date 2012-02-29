class CalculatePoints < ActiveRecord::Migration
  def up
    Point.delete_all
    Profile.all.each do |profile|
      profile.update_attribute(:points, 100)
      profile.pillars.each { |pillar| Point.create(subject: pillar, profile: profile) }
      profile.avatars.each { |avatar| Point.create(subject: avatar, profile: profile) }
      profile.event_items.each { |event_item| Point.create(subject: event_item, profile: profile) }
      profile.favorites.each { |favorite| Point.create(subject: favorite, profile: favorite.favorite) }
      ((Date.today - profile.created_at.to_date).to_i/7).times { Point.create(subject_type: 'Week', profile: profile) }
    end
  end
end
