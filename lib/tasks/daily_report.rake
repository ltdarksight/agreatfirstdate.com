namespace :daily_report do
  desc 'Create and send daily report'
  task :create => :environment do
    # New users and their e-mail addresses each day
    new_users = User.find :all, 
      conditions: ["created_at > ? AND created_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]
    
    # Total number of users
    total_users = User.all.size
    
    # Total number of active daily users
    active_daily_users = User.find :all, conditions: ["updated_at > ? AND updated_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]
    total_active_daily_users = active_daily_users.size
    
    # A list of each user and their points

    
    # Breakdown of pillar selections (total number of each pillar selected)
    pillars = Pillar.all
    total_pillars = pillars.size
    
    # Total number of events added
    
    
    # Numbers of e-mails sent
  end
end
