class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  def render_404
    render 'pages/404', :status => 404
  end
end
