class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    facebook_info =  request.env['omniauth.auth']
    facebook_id = facebook_info[:uid]
    profile_pic = facebook_info[:credentials][:info][:image]
    member = Member.where(facebook_id: facebook_id).first
    unless member
      member = Member.new \
        email: facebook_info[:credentials][:info][:email], 
        facebook_id: facebook_id, 
        profile_pic: profile_pic, 
        password: 'yt*k*$GY$-ULKf3qy$O',
        password_confirmation: 'yt*k*$GY$-ULKf3qy$O'
      member.skip_confirmation!
    end
    
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