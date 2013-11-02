module ApplicationHelper

  def set_current_user_in_javascript
    return unless user_signed_in?
    user = UserPresenter.new(current_user).to_json
    profile = ProfilePresenter.new(current_user.profile).to_json scope: :self

    content_tag(:script) do
      <<-JS.html_safe
        window.current_user_attributes = #{ user };
        window.current_profile_attributes = #{ profile };
      JS
    end
  end

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
    if profile.stripe_customer_token.present?
      'Verified!'
    else
      if profile.stripe_customer_token.blank?
        'Customer not active.'
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

  def link_to_privacy_policy
    link_to 'privacy policy', welcome_privacy_path, :target => "_blank"
  end

  def link_to_terms_of_use
    link_to 'terms of use', welcome_terms_path, :target => "_blank"
  end

  def display_user_points
    points = current_user.profile.points

    # Makes points tickable after third sign in in the day
    if current_user.third_sign_in_today? && allow_tick_sign_in_points?
      points -= Point::EVENT_TYPES['Session']
      session[:sign_in_points_ticked] = true
    end

    content_tag :span, "#{ points } Points", id: :my_points
  end

  def allow_tick_sign_in_points?
    !session[:sign_in_points_ticked]
  end
end
