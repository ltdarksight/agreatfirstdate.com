require 'csv'
require 'fileutils'
namespace :daily_report do
  desc 'Create and send daily report'
  task :create => :environment do
    daily_stat = {}
    # New users and their e-mail addresses each day
    daily_stat[:new_users] = User.find :all,
      conditions: ["created_at > ? AND created_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]

    # Total number of users
    daily_stat[:users] = User.all

    # Total number of active daily users
    daily_stat[:active_daily_users] = User.find :all, conditions: ["updated_at > ? AND updated_at < ?", Time.zone.now.beginning_of_day - 1.day, Time.zone.now.end_of_day - 1.day]

    # A list of each user and their points


    # Breakdown of pillar selections (total number of each pillar selected)
    daily_stat[:pillars] = Pillar.all
    daily_stat[:total_pillars] = daily_stat[:pillars].size
    daily_stat[:pillar_categories] = PillarCategory.all

    # Total number of events added
    daily_stat[:event_items] = EventItem.all

    # Numbers of e-mails sent


    DailyReportMailer.daily_report(daily_stat).deliver
  end

  desc "Daily events reports"
  task :events => :environment do
    begin
      date_report = Time.current
      tmp_report = Rails.root.join("tmp", date_report.strftime("evens_report_%m%d%Y.csv")).to_s
      count_events = 0
      CSV.open(tmp_report, "wb") do |csv|
        csv << ["signup date", "link to profile", "first name", "last name", "gender", "pillar name", "event name", "event date", "event description"]
        Pillar.unscoped{
          EventItem.includes(:pillar, :user).sort_by(&:profile).each do |event|
            count_events += 1
            csv << [
                    event.user.created_at,
                    "http://#{Agreatfirstdate::Application.config.app_host}/profiles/#{event.profile.to_param}",
                    event.profile.first_name,
                    event.profile.last_name,
                    event.profile.gender,
                    event.pillar.name,
                    event.title,
                    (event.date_1 || event.date_2),
                    event.description
                   ]
          end
          Profile.find_each do |profile|
            if profile.event_items.empty?
              csv << [
                      profile.user.created_at,
                      "http://#{Agreatfirstdate::Application.config.app_host}/profiles/#{profile.to_param}",
                      profile.first_name,
                      profile.last_name,
                      profile.gender,
                      '-',
                      '-',
                      '-',
                      '-'


                     ]
            end
          end
        }
      end

      DailyReportMailer.daily_events_report(date_report, count_events, tmp_report).deliver

    ensure

      FileUtils.rm_f(tmp_report)
    end

  end

end
