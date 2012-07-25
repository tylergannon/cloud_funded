module RequestSpecs
  module SignInMemberHelper
    def sign_in_member(member=nil, password=nil)
      @password ||= (password || 'nicebaq')
      @member ||= (member || FactoryGirl.create(:member, email: 'somebosy@foozball.com', password: @password, password_confirmation: @password))
      visit new_member_session_path
      fill_in 'Email', with: @member.email
      fill_in 'Password', with: @password
      click_button 'Sign in'
    end
  end
end