class DailyReportMailer < BaseMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_report.send.subject
  #
  def daily_report(daily_stat)
    @daily_stat = daily_stat
    
    mail to: "manzhikov@gmail.com"
  end
end
