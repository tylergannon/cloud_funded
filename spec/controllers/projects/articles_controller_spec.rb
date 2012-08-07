require 'spec_helper'

describe Projects::ArticlesController do
  render_views
  
  before :each do
    sign_in_as_member
    @owner = FactoryGirl.create :member
    stub_attachments_for(Project)
    @project = FactoryGirl.create :project, owner: @owner
    @article = FactoryGirl.create :published_article, author: @owner, project: @project
  end
  
  def valid_attributes
    {
      
    }
  end
  
  describe "get index" do
    before :each do
      get :index, project_id: @project.to_param
    end
    it "should load the project" do
      assigns(:project).should == @project
    end
    it "should grab the correct articles." do
      assigns(:articles).should == [@article]
    end
  end
  
  describe "get show" do
    before :each do
      get :show, project_id: @project.to_param, id: @article.to_param
    end
    it "should load the project" do
      assigns(:project).should == @project
    end
    it "should grab the correct article." do
      assigns(:article).should == @article
    end
    it "should respond with success" do
      response.status.should == 200
    end
    it "should set the title" do
      assigns(:title).should == @article.title
    end
  end
  
  describe "post #publish" do
    before :each do
      @article.workflow_state = 'unpublished'
      @article.save!
      @article.should be_unpublished
      sign_in @owner
      post :publish, project_id: @project.to_param, id: @article.to_param, format: 'json'
    end
    it "should be published" do
      assigns(:article).should be_published
    end
    it "should give a 200 status" do
      response.status.should == 200
    end
  end
  
  describe "get new" do
    
  end
end
