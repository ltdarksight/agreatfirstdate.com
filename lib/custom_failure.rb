class CustomFailure < Devise::FailureApp
  def redirect_url
    if (request_path = request.get? ? attempted_path : request.referrer)[/confirm_email\Z/]
      request_path
     else
      super
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
