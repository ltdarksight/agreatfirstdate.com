class DailyReportMailer < BaseMailer
  REPORT_EMAIL = "feedback@agreatfirstdate.com"
  BCC_REPORT_EMAILS = "parallel588@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_report.send.subject
  #
  def daily_report(daily_stat)
    @daily_stat = daily_stat

    mail to: REPORT_EMAIL
  end

  def daily_events_report(date_report, count_events, csv_path)
    @date_report = date_report
    @count_events = count_events
    attachments[File.basename(csv_path)] = File.read(csv_path)
    mail to: REPORT_EMAIL, bcc: BCC_REPORT_EMAILS
  end
end
