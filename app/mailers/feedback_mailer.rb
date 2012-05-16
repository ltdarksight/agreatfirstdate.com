class FeedbackMailer < ActionMailer::Base
  default from: "no-reply@agreatfirstdate.com"
  default to: "feedback@agreatfirstdate.com"

  def feedback(feedback)
    @feedback = feedback
    mail(
      :subject => "AGreatFirstDate - Feedback"
    )
  end
end
