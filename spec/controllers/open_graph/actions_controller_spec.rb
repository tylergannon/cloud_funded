require 'spec_helper'

describe OpenGraph::ActionsController do
  before :each do
    sign_in_as_member
  end
  
  def signed_request
 'pn4oc6tNK_GThtGQkCNjx1f4ilCxKcvPh2Ewb_i0rXE.eyJhY3Rpb25fbGluayI6eyJ0eXBlIjoiY2xvdWRmdW5kZWRkZXY6Zm9sbG93X2NvbXBhbnkifSwiYWN0aW9ucyI6W3siaWQiOiIxMDEwMDQ4Nzc3NDMzMzE4OCJ9XSwiYWxnb3JpdGhtIjoiSE1BQy1TSEEyNTYiLCJleHBpcmVzIjoxMzQ0NzUxMjAwLCJpc3N1ZWRfYXQiOjEzNDQ3NDY2OTgsIm9hdXRoX3Rva2VuIjoiQUFBRm9HdnNOdVl3QkFPcFZqVFFhOWxaQ2ZCdFpBNHJoM3RYQ0MzcFpCQnR5b1doOHM5Mm53TjhxNmk4QmpDWkFhN2Q2clpCU2Q1aWgxVWtlU2FhdU40cHUwS1NaQUVVdlNHZ1dVTTk2V25qZ1pEWkQiLCJvYmplY3RzIjpbeyJ1cmwiOiJodHRwOlwvXC9kZXYuY2xvdWRmdW5kZWQuY29tXC93aXp6eSJ9XSwidXNlciI6eyJjb3VudHJ5IjoidXMiLCJsb2NhbGUiOiJlbl9VUyJ9LCJ1c2VyX2lkIjoiNjcxNDU2NSJ9'
  end
  
  describe '#follow' do
    before :each do
      @member = FactoryGirl.create :member, facebook_id: "6714565"
      @project = FactoryGirl.create :project, name: 'wizzy'
    end

    it "should create a new 'Follow' action" do
      expect {
        get :follow, format: 'json', signed_request: signed_request
      }.to change(OpenGraph::Follow, :count).by(1)
    end

    it "should create a new 'Update' action" do
      expect {
        get :follow, signed_request: signed_request, format: 'json'
      }.to change(Members::Updates::FollowUpdate, :count).by(1)
    end

    describe "what it does" do
      before :each do
        get :follow, signed_request: signed_request
      end
      it "should add the project to my followed projects list" do
        @member.reload
        @member.followed_projects.should include(@project)
      end
      it "should come up on the other side too" do
        @project.reload
        @project.followers.should include(@member)
      end
      
      describe "creates an update" do
        before :each do
          @update = Members::Updates::FollowUpdate.last
        end
        it "should have member equal to the owner of the project" do
          @update.member.should == @project.owner
        end
        it "should not be read" do
          @update.should_not be_read
        end
        it "should have the correct follower" do
          @update.follower.should == @member
        end
        it "should have the correct project" do
          @update.project.should == @project
        end
      end
    end
  end
  
  describe '#create' do
    # describe "when signed in as admin" do
    #   it "should still create the "
    # end
    it "should create an object" do
      expect {
        post :create, format: 'json', open_graph_action: {
          action_id: '2345234523452345',
          type: 'OpenGraph::Like',
          graph_object_type: 'Project',
          graph_object_id: 1234123
        }
      }.to change(OpenGraph::Action, :count).by(1)
    end
    
    describe "creates an open graph action record with the correct attributes" do
      before :each do
        post :create, format: 'json', open_graph_action: {
          action_id: '2345234523452345',
          type: 'OpenGraph::Like',
          graph_object_type: 'Project',
          graph_object_id: 1234123
        }
        @action = OpenGraph::Action.last
      end
      it "should have the correct action_id" do
        @action.action_id.should == '2345234523452345'
      end
      it "should have the correct type" do
        @action.type.should == 'OpenGraph::Like'
      end
      it "should have the correct graph_object_type" do
        @action.graph_object_type.should == 'Project'
      end
      it "should have the correct graph_object_id" do
        @action.graph_object_id.should == 1234123
      end
      it "should have the correct member_id" do
        @action.member_id.should == @member.id
      end
    end
  end
end
