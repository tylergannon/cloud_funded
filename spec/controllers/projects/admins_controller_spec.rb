require 'spec_helper'

describe Projects::AdminsController do
  render_views
  
  before(:each) do
    sign_in_as_member
    @admin = FactoryGirl.create :member
    @project = FactoryGirl.create :project, owner: @member
  end
  describe "get #index" do
    before :each do
      @project.admins << @admin
      get :index, project_id: @project.to_param
    end
    it "should load the admins of the project" do
      assigns(:admins).should == [@admin]
    end
  end
  
  describe "get #new" do
    
  end
  
  describe "post #create" do
    before :each do
      post :create, project_id: @project.to_param, member_id: @admin.id, format: :js
    end
    it "should add the member to the admins group for the project" do
      assigns(:project).admins.should include(@admin)
    end
    it "should assign the member to the @admin variable" do
      assigns(:admin).should == @admin
    end
    it "should send an email to the person" do
      ActionMailer::Base.deliveries.last.to.should == [assigns(:admin).email]
    end
  end
  
  describe "delete #destroy" do
    before :each do
      @project.admins << @admin
      delete :destroy, project_id: @project.to_param, id: @admin.id, format: :js
    end
    it "should add the member to the admins group for the project" do
      assigns(:project).admins.should_not include(@admin)
    end
  end
end
