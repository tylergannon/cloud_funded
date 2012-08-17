class Admin::ProjectsController < ApplicationController
  before_filter :authenticate_admin!
  def index
    @projects = Project.all
    respond_with @projects do |format|
      format.html {
        render layout: 'admin'
      }
    end
  end
  
  def update
    @project = Project.find(params[:id])
    @project.update_attributes params[:project]
    respond_with(@project) do |format|
      format.html {
        redirect_to admin_projects_path
      }
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_with(@project) do |format|
      format.html {
        redirect_to admin_projects_path
      }
    end
  end
  
  def authenticate_admin!
    authenticate_member!
    authorize! :manage, Project
  end
end
