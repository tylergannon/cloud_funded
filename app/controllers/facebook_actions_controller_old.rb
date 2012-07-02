class FacebookActionsController < ApplicationController
  respond_to :json
  before_filter :load_parent
  
  def show
    respond_with(@project) do |format|
      format.json {render json: {id: @project.fb_post_id}}
    end
  end
  
  def create
    # authorize! :manage, @project
    id = CloudFunded::Facebook::Actions.create_project(project_url(@project), current_member.fb_token)
    @project.update_attributes! fb_post_id: id
    respond_with(id) do |format|
      format.json {
        render json: {id: id}
      }
    end
  end
  
  def destroy
    CloudFunded::Facebook::Actions.remove_action(@project.fb_post_id, current_member.fb_token)
    @project.update_attributes fb_post_id: nil
    respond_with @project do |format|
      format.json {render json: true}
    end
  end
  
  def load_parent
    @project = Project.find(params[:project_id])
  end
end
