require 'spec_helper'

describe Projects::WizardController do
  describe "get #show" do
    describe "when id=finish" do
      describe "when post_to_fb is set" do
        before :each do
          Project.any_instance.stub(:save_attached_files).and_return(true)
          Project.any_instance.stub(:destroy_attached_files).and_return(true)
          Paperclip::Attachment.any_instance.stub(:queue_all_for_delete).and_return(true)
          Paperclip::Attachment.any_instance.stub(:present?).and_return(true)
          @member = FactoryGirl.create :member, fb_token: 'nicebaq'
          @project = FactoryGirl.create :project, owner: @member,
                     post_to_fb: true
          sign_in @member
        end
        
        it "should call out to the Facebook action." do
          CloudFunded::Facebook::Actions.should_receive(:create_project).and_return('rockstar') do |url, fb_token|
            url.should == project_url(@project)
            fb_token.should == @member.fb_token
          end
          get :show, {project_id: @project.to_param, id: 'finish'}
        end
        
        it "should save the fb post id to the project." do
          CloudFunded::Facebook::Actions.stub(:create_project).and_return('rockstar')
          get :show, {project_id: @project.to_param, id: 'finish'}
          assigns(:project).fb_post_id.should == 'rockstar'
        end
      end
    end
  end
end