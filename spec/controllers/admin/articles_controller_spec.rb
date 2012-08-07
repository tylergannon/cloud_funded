require 'spec_helper'

describe Admin::ArticlesController do
  render_views
  
  before :each do
    sign_in_as_admin
    @member = FactoryGirl.create :member, admin: true
    @article = FactoryGirl.create :article, author: @member
  end
  
  describe "post #publish" do
    before :each do
      @article.should be_unpublished
      sign_in @member
      post :publish, project_id: @project.to_param, id: @article.to_param, format: 'json'
    end
    it "should be published" do
      assigns(:article).should be_published
    end
    it "should give a 200 status" do
      response.status.should == 200
    end
  end
end
