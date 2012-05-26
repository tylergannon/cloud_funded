class ApplicationController < ActionController::Base
  responders :flash, :http_cache
  respond_to :html
  protect_from_forgery
  
  def current_ability
    @current_ability ||= Ability.new(current_member)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    if member_signed_in?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to new_member_session_path, :alert => exception.message
    end
  end
end
