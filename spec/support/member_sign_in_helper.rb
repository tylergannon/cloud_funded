module MemberSignInHelper
  def sign_in_as_member
    @member ||= FactoryGirl.create :member
    sign_in @member # method from devise:TestHelpers
  end
end
