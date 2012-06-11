namespace :daily_report do
  desc 'Create and send daily report'
  task :create => :environment do
    daily_stat = {}
    # New users and their e-mail addresses each day
    daily_stat[:new_users] = User.find :all, 
      conditions: ["created_at > ? AND created_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]
    
    # Total number of users
    daily_stat[:total_users] = User.all.size
    
    # Total number of active daily users
    daily_stat[:active_daily_users] = User.find :all, conditions: ["updated_at > ? AND updated_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]
    daily_stat[:total_active_daily_users] = daily_stat[:active_daily_users].size
    
    # A list of each user and their points

    
    # Breakdown of pillar selections (total number of each pillar selected)
    daily_stat[:pillars] = Pillar.all
    daily_stat[:total_pillars] = daily_stat[:pillars].size
    
    # Total number of events added
    
    
    # Numbers of e-mails sent
    
    DailyReportMailer.daily_report(daily_stat).deliver
  end
end
