require 'yaml'

class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  after_filter CloudFunded::Twitter::SetTwitterIdFilter, except: :twitter
  
  include Members
  def dwolla
    @next_location = session[:last_request] || root_path

    unless params[:error].blank?
      flash[:error] = "There was a problem signing in to your Dwolla account.  We have been notified and are working on a solution."
      request.env['omniauth.auth'].clear
    else
      authenticate_member!
      
      dwolla_info =  request.env['omniauth.auth']
      current_member.attributes= {dwolla_id: dwolla_info.uid, 
                                  dwolla_auth_token: dwolla_info.credentials.token}
      current_member.save!
    end

    render 'dwolla', layout: false
    # redirect_to @next_location
  end
  
  def twitter
    twitter_info =  request.env['omniauth.auth']
    @twitter_login = TwitterLogin.where(user_id: twitter_info.uid).first

    if member_signed_in?
      @member = current_member
    end
    
    if @twitter_login
      @member = @twitter_login.member
      raise "this is not good" if current_member != @member_signed_in
      @twitter_login.update_attributes \
        location:    twitter_info.info.location,
        name:        twitter_info.info.name,
        nickname:    twitter_info.info.nickname,
        profile_pic: twitter_info.info.image,
        profile_url: twitter_info.info.urls.Twitter,
        token:       twitter_info.credentials.token
    else
      @twitter_login = TwitterLogin.create \
        location:    twitter_info.info.location,
        name:        twitter_info.info.name,
        nickname:    twitter_info.info.nickname,
        profile_pic: twitter_info.info.image,
        profile_url: twitter_info.info.urls.Twitter,
        token:       twitter_info.credentials.token,
        user_id:     twitter_info.uid
      if @member
        @member.twitter_login_id = @twitter_login.id
        @member.save!
      end
    end
    
    if member_signed_in?
      redirect_to session[:last_request] || root_path
    else
      if @member
        sign_in_and_redirect @member, :event => :authentication
      else
        session[:twitter_login_id] = @twitter_login.id
        redirect_to new_member_session_path
      end
    end
  end
  
  def facebook
    facebook_info =  request.env['omniauth.auth']
    facebook_id = facebook_info.uid
    @member = Member.where(facebook_id: facebook_id).first

    unless @member
      @member = Member.new \
        email: facebook_info.info.email, 
        facebook_id: facebook_id, 
        password: 'yt*k*$GY$-ULKf3qy$O',
        password_confirmation: 'yt*k*$GY$-ULKf3qy$O'
      @member.skip_confirmation!
      MemberMailer.new_member(@member).deliver
    end

    @member.attributes = {
      profile_pic: facebook_info.info.image,
      profile: facebook_info.info.urls.Facebook,
      first_name: facebook_info.info.first_name,
      last_name: facebook_info.info.last_name,
      fb_token: facebook_info.credentials.token}
    
    @member.save

    sign_in_and_redirect @member, :event => :authentication
    
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