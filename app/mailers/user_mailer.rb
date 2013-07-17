class UserMailer < BaseMailer


  def charge_failed(profile)
    @profile = profile
    mail(
         :to => @profile.user.email,
         :bcc => 'admin@agreatfirstdate.com',
         :subject => "AGreatFirstDate - Uh oh. Something happened and we couldn't process your transaction."
         )

  end

  def charge_succeeded(profile)
    @profile = profile
    mail(
         :to => @profile.user.email,
         :subject => "AGreatFirstDate - Your payment was successful"
         )

  end

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
