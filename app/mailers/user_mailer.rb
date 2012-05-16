class UserMailer < ActionMailer::Base
  default from: "no-reply@agreatfirstdate.com"

  def say_hi(email)
    @recipient = email.recipient.profile
    @sender = email.sender.profile
    @email = email
    mail(
      :to => @recipient.user.email,
      :subject => "AGreatFirstDate - Message from #{@sender.short_name}"
    )
  end
end
