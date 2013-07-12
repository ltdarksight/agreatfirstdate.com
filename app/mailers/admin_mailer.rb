class AdminMailer < BaseMailer

  def cancel_account(profile)
    @profile = profile
    mail(
         :to => "admin@agreatfirstdate",
         :subject => "AGreatFirstDate - Cancel account: #{@profile.full_name}"
         )
  end
end
