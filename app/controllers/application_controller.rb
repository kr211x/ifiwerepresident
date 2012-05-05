class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  include Authentication
  
  before_filter :check_subdomain
  
  def check_subdomain
    if Rails.env.production? and request.host.downcase == 'ribbot.herokuapp.com'
      redirect_to request.protocol + 'ribbot.com' + request.fullpath, :status => 301
    end
  end
  
  LOCAL = ['ribbot.com', 'ribbot.local', 'localhost', 'example.com'].to_set
  
  def current_theme
    @current_theme ||= get_current_theme
  end
  helper_method :current_theme
  
  def get_current_theme
    if params[:theme_preview].present?
      Theme.where(:_id => params[:theme_preview]).first
    else
      nil
    end
  end
    
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
