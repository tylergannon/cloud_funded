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
  
  describe "post #create" do
    describe "when I am not allowed to edit the project" do
      before :each do
        post :create, project_id: @project.to_param
      end
      it "should be unauthorized" do
        response.status.should == 404
      end
    end
    describe "when I am allowed to edit the project" do
      before :each do
        @project.admins << @member
      end
      it "should create a new article" do
        expect {
          post :create, project_id: @project.to_param
        }.to change(Article, :count).by(1)
      end
      describe "results" do
        before :each do
          post :create, project_id: @project.to_param
        end
        it "should create a new article that belongs to the project" do
          assigns(:article).project.should == @project
        end
        it "should redirect to the editor page for the project, on the updates tab." do
          response.should redirect_to('/editor' + project_path(@project) + '/updates')
        end
      end
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
