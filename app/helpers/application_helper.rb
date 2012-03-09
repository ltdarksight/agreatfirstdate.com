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
end

