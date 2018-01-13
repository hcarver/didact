class ApplicationController < ActionController::Base
  before_filter :ensure_domain
  protect_from_forgery
  
  APP_DOMAIN = 'www.pogohop.com'

  def ensure_domain
    if Rails.env == 'production' and request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end
end