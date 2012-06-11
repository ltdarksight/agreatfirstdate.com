class InappropriateContentMailer < BaseMailer

  def inappropriate(inappropriate_content)
    @inappropriate_content = inappropriate_content
    @content = inappropriate_content.content

    mail(
      :to => user_for(inappropriate_content).email,
      :subject => "AGreatFirstDate - Inappropriate content"
    )
  end

  def still_inappropriate(inappropriate_content)
    @inappropriate_content = inappropriate_content
    @content = inappropriate_content.content

    mail(
      :to => user_for(inappropriate_content).email,
      :subject => "AGreatFirstDate - Inappropriate content"
    )
  end

  def appropriate(inappropriate_content)
    @inappropriate_content = inappropriate_content
    @content = inappropriate_content.content

    mail(
      :to => user_for(inappropriate_content).email,
      :subject => "AGreatFirstDate - Inappropriate content"
    )
  end

  def check_appropriate(inappropriate_content)
    @inappropriate_content = inappropriate_content
    @content = inappropriate_content.content
    user_for(inappropriate_content)

    mail(
      :to => 'admin@agreatfirstdate.com',
      :subject => "AGreatFirstDate - Inappropriate content"
    )
  end
  private
  def user_for(inappropriate_content)
    @user ||= case inappropriate_content.content_type
      when 'Profile', 'EventItem'
        inappropriate_content.content.user
    end
  end
end


