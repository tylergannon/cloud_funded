class ApplicationController < ActionController::Base
  responders :flash, :http_cache
  respond_to :html
  protect_from_forgery
  
  def current_ability
    @current_ability ||= Ability.new(current_member)
  end
end
