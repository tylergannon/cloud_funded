require 'spec_helper'

describe Projects::PerksController do
  render_views
  before(:each) do
    sign_in_as_member
    @project = FactoryGirl.create :project, owner: @member
    @unauthorized_project = FactoryGirl.create :project
  end
  describe "post create" do
    describe "if I own the project" do
      it "should allow me to create it" do
        expect {
          post :create, project_id: @project.to_param, format: :js
          response.status.should == 200
        }.to change(Projects::Perk, :count).by(1)
      end
    end
    
    describe "if I do not own the project" do
      it "should not allow me to create it" do
        expect {
          post :create, project_id: @unauthorized_project.to_param
        }.to change(Projects::Perk, :count).by(0)
      end
      it "should result in an error" do
        post :create, project_id: @unauthorized_project.to_param, format: :js
        response.status.should == 401
      end
    end
  end
  describe "put update" do
    describe "if I own the project" do
      before :each do
        @perk = @project.perks.first
        put :update, project_id: @project.to_param, id: @perk.to_param, format: :json, perk: {
          name: 'blahblah'
        }
      end
      it "should succeed" do
        response.status.should == 200
      end
      it "should update the perk" do
        @perk.reload
        @perk.name.should == 'blahblah'
      end
    end
    
    describe "if I do not own the project" do
      before :each do
        @perk = @unauthorized_project.perks.first
        put :update, project_id: @unauthorized_project.to_param, id: @perk.to_param, format: :json, perk: {
          name: 'blahblah'
        }
      end
      it "should succeed" do
        response.status.should == 401
      end
      it "should update the perk" do
        @perk.reload
        @perk.name.should_not == 'blahblah'
      end
    end
  end
end
