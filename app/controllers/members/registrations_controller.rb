class Members::RegistrationsController < Devise::RegistrationsController
  after_filter CloudFunded::Twitter::SetTwitterIdFilter, only: :create
  
  def create
    if session[:omniauth] == nil #OmniAuth
      if verify_recaptcha
        super
        # session[:omniauth] = nil unless current_member.new_record? #OmniAuth
      else
        build_resource
        clean_up_passwords(resource)
        flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
        render :new 
      end
    else
      super
      session[:omniauth] = nil unless current_member.new_record? #OmniAuth
    end
  end
end
