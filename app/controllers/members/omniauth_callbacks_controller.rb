require 'yaml'

class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def dwolla
    authenticate_member!
    dwolla_info =  request.env['omniauth.auth']
    current_member.attributes= {dwolla_id: dwolla_info.uid, 
                                dwolla_auth_token: dwolla_info.credentials.token}
    current_member.save!
    render text: params.inspect
  end
  
  def facebook
    facebook_info =  request.env['omniauth.auth']
    facebook_id = facebook_info.uid
    member = Member.where(facebook_id: facebook_id).first

    unless member
      member = Member.new \
        email: facebook_info.info.email, 
        facebook_id: facebook_id, 
        password: 'yt*k*$GY$-ULKf3qy$O',
        password_confirmation: 'yt*k*$GY$-ULKf3qy$O'
      member.skip_confirmation!
      MemberMailer.new_member(member).deliver
    end

    member.attributes = {
      profile_pic: facebook_info.info.image,
      profile: facebook_info.info.urls.Facebook,
      first_name: facebook_info.info.first_name,
      last_name: facebook_info.info.last_name,
      fb_token: facebook_info.credentials.token}
    
    member.save
    

    sign_in_and_redirect member, :event => :authentication
    
    # # You need to implement the method below in your model
    # @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    # 
    # if @user.persisted?
    #   flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    #   sign_in_and_redirect @user, :event => :authentication
    # else
    #   session["devise.facebook_data"] = request.env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end
  end
end