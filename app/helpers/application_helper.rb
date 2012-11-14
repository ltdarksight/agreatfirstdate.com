module ApplicationHelper

  def resource_name
    :user
  end
  
  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def profile
    current_user.profile
  end

  def card_status(profile)
    if profile.card_verified?
      'Verified!'
    else
      if !profile.customer_status
        'Customer not verified.'
      elsif !profile.customer_subscription_status
        'Customer ends subscription.'
      elsif !profile.invoice_status
        'Invoice attempts to be paid, and the payment fails.'
      end
    end
  end

  def seo(data = {})
    content_for :title, data[:title]
    content_for :description, data[:description]
    content_for :keywords, data[:keywords]
  end

  def seo_description
    if content_for? :description
      content_for(:description)
    end
  end

  def seo_title
    if content_for? :title
      content_for(:title)
    else
      t 'seo.title'
    end
  end
end
