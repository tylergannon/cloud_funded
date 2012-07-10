class Projects::WizardController < ApplicationController
  include Wicked::Wizard
  steps :where, :share, :add_urls
  before_filter :load_project, :authenticate_action!
  
  def show
    if @project.post_to_fb
      @project.fb_post_id = CloudFunded::Facebook::Actions.create_project project_url(@project), current_member.fb_token          
      @project.save!
    end

    render_wizard
  end
  
  def update
    if params[:project]
      @project.update_attributes params[:project]
    end
    if methods.include?(step)
      send(step)
    end
    render_wizard(@project)
  end
  
  def load_project
    @project = Project.find(params[:project_id])
  end
  
  def authenticate_action!
    authenticate_member!
    authorize! :edit, @project
  end
end
