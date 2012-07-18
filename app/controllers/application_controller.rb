class ApplicationController < ActionController::Base
  responders :flash, :http_cache
  respond_to :html
  protect_from_forgery
  
  def current_ability
    @current_ability ||= Ability.new(current_member)
  end
    
  rescue_from CanCan::AccessDenied do |exception|
    if member_signed_in?
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", formats: [:html], :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :unauthorized }
      end
      # raise ActionController::RoutingError.new('Not Found')
      # redirect_to root_url, :alert => exception.message
    else
      redirect_to new_member_session_path, :alert => exception.message
    end
  end
  
  private
  def authenticate_admin
    authenticate_member!
    authorize! :manage, :all
  end
end
