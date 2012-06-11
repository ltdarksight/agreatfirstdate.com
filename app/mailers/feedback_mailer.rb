class FeedbackMailer < BaseMailer
  default to: "feedback@agreatfirstdate.com"

  def feedback(feedback)
    @feedback = feedback
    mail(
      :subject => "AGreatFirstDate - Feedback"
    )
  end
end
