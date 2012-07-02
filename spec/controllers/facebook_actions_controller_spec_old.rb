require 'spec_helper'

describe FacebookActionsController do
  before :each do 
    @member = FactoryGirl.create(:member, fb_token: 'AAAEyIBSfsVoBAEQ2VcxOEcOF0Ks5XcFW4vb1rUBgfZCZCoQX1ffoJkLoYKBVtBNZCAfL0EFA194QyYDm8ZAuRc7Xy5X6R2otnR3eGwocCQZDZD')
    sign_in :member, @member
    Project.any_instance.stub(:save_attached_files).and_return(true)
    Project.any_instance.stub(:destroy_attached_files).and_return(true)
    Paperclip::Attachment.any_instance.stub(:queue_all_for_delete).and_return(true)
    @project = FactoryGirl.create(:project, owner: @member)
  end
  
  describe "create" do
    it "should set the fb_action_id attribute" do
      CloudFunded::Facebook::Actions.should_receive(:create_project).
                                     and_return('blahblah') 
      post :create, {project_id: @project.id, format: :json}
      @project.reload
      @project.fb_post_id.should == 'blahblah'
    end
  end
  
  describe "show" do
    before :each do
      @project.update_attributes fb_post_id: 'blahblah'
    end
    it "should return the id" do
      get :show, {project_id: @project.id, format: :json}
      response.body.should == "{\"id\":\"blahblah\"}"
    end
  end

  describe "destroy" do
    before :each do
      @project.update_attributes fb_post_id: 'blahblah'
    end
    it "should remove the action" do
      CloudFunded::Facebook::Actions.should_receive(:remove_action) do |id, token|
        id.should == 'blahblah'
        token.should == @member.fb_token
      end
      delete :destroy, {project_id: @project.id, format: :json}
    end
  end
end
