require 'spec_helper'

describe Members::OmniauthCallbacksController do
  before :each do
    @member = FactoryGirl.create :member
    @facebook_info = OmniAuth.config.mock_auth[:facebook]
    @dwolla_info = OmniAuth.config.mock_auth[:dwolla]
    @twitter_info = OmniAuth.config.mock_auth[:twitter]
  end
  
  describe "twitter" do
    describe "When twitter login is successful" do
      before :each do
        request.env["omniauth.auth"] = @twitter_info
      end
      describe "when I am already logged in" do
        before :each do
          sign_in @member
        end
        describe "and I haven't connected my twitter account" do
          it "should create a new TwitterLogin" do
            expect {get :twitter}.to change(Members::TwitterLogin, :count).by(1)
          end
          it "should not create a new member" do
            expect {get :twitter}.to change(Member, :count).by(0)
          end
          it "should connect the new TwitterLogin to my account" do
            get :twitter
            @member.reload
            @member.twitter_login.should == assigns(:twitter_login)
          end
        end
      end
      describe "when the person does not have a CloudFunded account" do
        it "should not create a new member" do
          expect {get :twitter}.to change(Member, :count).by(0)
        end
        it "should redirect to the new member sign in page" do
          get :twitter
          response.should redirect_to new_member_session_path
        end
        it "should set a session variable for twitter login" do
          get :twitter
          session[:twitter_login_id].should == assigns(:twitter_login).id
        end
        it "should create a twitter login" do
          expect {get :twitter}.to change(Members::TwitterLogin, :count).by(1)
        end
        describe "when there is already a TwitterLogin object" do
          before :each do
            get :twitter
          end
          it "should not create a new one" do
            expect {get :twitter}.to change(Members::TwitterLogin, :count).by(0)
          end
        end

        describe "New member attributes" do
          before :each do
            get :twitter
          end
          subject {Members::TwitterLogin.last}
          it "should have the correct attributes" do
            subject.email.should be_nil
            subject.location.should == 'Oakland, Ca'
            subject.member_id.should be_nil
            subject.name.should == 'Tyler Gannon'
            subject.nickname.should == 'tybo22'
            subject.profile_pic.should == 'http://a0.twimg.com/profile_images/350221530/Tyler_normal.jpeg'
            subject.profile_url.should == 'http://twitter.com/tybo22'
            subject.token.should == '63281177-fq1LNr8jQzjRTKtRGeYMkAhx3sMGOGf3eLoRjw8IU'
            subject.type.should == 'Members::TwitterLogin'
            subject.user_id.should == '63281177'
          end
          it "should redirect me." do
            response.should be_redirect
          end
        end
      end
    end
  end
  
  describe "dwolla" do
    describe "when Dwolla login is successful" do
      before :each do
        sign_in :member, @member
        request.env["omniauth.auth"] = @dwolla_info
        @dwolla_id = @dwolla_info.uid
        @dwolla_auth_token = @dwolla_info.credentials.token
        get :dwolla
        @member.reload
      end
      
      it "should set the auth token" do
        @member.dwolla_auth_token.should_not be_nil
        @member.dwolla_auth_token.should == @dwolla_auth_token
      end
      
      it "should set the member's Dwolla ID" do
        @member.dwolla_id.should == @dwolla_id
      end
    end
  end
  
  describe "facebook" do    
    describe "when FB login successful" do
      before(:each) {
        request.env["omniauth.auth"] = @facebook_info
        @facebook_id = OmniAuth.config.mock_auth[:facebook].uid.to_i
        @profile_pic = "http://graph.facebook.com/6714565/picture?type=square"
        @profile = OmniAuth.config.mock_auth[:facebook].info.urls.Facebook
        @fb_token = 'AAABx9U9GY9oBAIVg2qkV7Y6yQONgZCX4oKkwNaTZBO8VtLdPPF0ZBhDzVJmxt08sibhV6joQeSdkBeBpIZAKB2burXcR0UIZD'
      }
      it "should create a new member if one does not exist" do
        lambda {
          get :facebook
        }.should change(Member, :count).by(1)
      end
      
      describe "when Twitter login id is in the session" do
        it "should add the twitter login id to the member" do
          session[:twitter_login_id] = '234526'
          get :facebook
          assigns(:member).reload
          assigns(:member).twitter_login_id.should == 234526
        end
      end
      
      describe "when the member already exists" do
        before :each do
          @member = FactoryGirl.build :member, facebook_id: @facebook_id, profile_pic: @profile_pic
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
        it "should update the access token" do
          @member.fb_token.should be_nil
          get :facebook
          @member.reload
          @member.fb_token.should == @fb_token
        end
      end
      
      describe "when the member does not exist" do
        before :each do
          get :facebook
          @member = Member.last
        end
        it "should have the correct facebook id" do
          @member.facebook_id.should be == @facebook_id.to_s
        end
        it "should have the correct profile pic" do
          @member.profile_pic.should be == @profile_pic
        end
        it "should have the correct profile url" do
          @member.profile.should be == @profile
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
        it "should get the first name" do
          @member.first_name.should == "Tyler"
        end
        it "should get the last name" do
          @member.last_name.should == "Gannon"
        end
        it "should get the access token" do
          @member.fb_token.should == @fb_token
        end
      end
    end
  end
end