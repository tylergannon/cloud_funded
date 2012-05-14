require 'spec_helper'

describe Members::OmniauthCallbacksController do
  describe "facebook" do
    before :each do
      include Devise::TestHelpers
      request.env["devise.mapping"] = Devise.mappings[:member]
    end
    
    describe "when FB login successful" do
      before(:each) {
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        @facebook_id = OmniAuth.config.mock_auth[:facebook][:uid].to_i
        @profile_pic = "http://graph.facebook.com/6714565/picture?type=square"
      }
      it "should create a new member if one does not exist" do
        lambda {
          get :facebook
        }.should change(Member, :count).by(1)
      end
      
      describe "when the member already exists" do
        before :each do
          @member = Factory.build :member, facebook_id: @facebook_id, profile_pic: @profile_pic
          @member.skip_confirmation!
          @member.save!
        end
        it "should not create a new member" do
          lambda {
            get :facebook
          }.should_not change(Member, :count)
        end
        it "should redirect to the correct place" do
          get :facebook
          response.should redirect_to(root_path)
        end
        it "should sign in the member" do
          get :facebook
          controller.current_member.should == @member
        end
      end
      
      describe "when the member does not exist" do
        before :each do
          get :facebook
          @member = Member.last
        end
        it "should have the correct facebook id" do
          @member.facebook_id.should be == @facebook_id
        end
        it "should have the correct profile pic" do
          @member.profile_pic.should be == @profile_pic
        end
        it "should redirect to root path" do
          response.should redirect_to(root_path)
        end
        it "should log in a member" do
          controller.member_signed_in?.should be_true
        end
        it "should log in the correct member" do
          controller.current_member.should == @member
        end
      end
    end
  end
end