module AdminMemberSignInHelper
  def sign_in_as_admin
    @member ||= FactoryGirl.create :member, admin: true
    sign_in @member # method from devise:TestHelpers
  end
end
