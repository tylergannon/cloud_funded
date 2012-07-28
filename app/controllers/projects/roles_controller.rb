class Projects::RolesController < ApplicationController
  respond_to :js
  before_filter :authenticate_member!, :load_project
  
  def new
    authorize! :edit, @project
    @role = @project.roles.build
    @role.invited_by = current_member
    respond_with @project, @role
  end
  
  def create
    authorize! :edit, @project
    @role = @project.roles.build(params[:role])
    @role.invited_by = current_member
    @member = Member.where(email: @role.email_address).first
    if @member
      @role.member = @member
    end
    @role.save
    respond_with @project, @role
  end
  
  def confirm
    @role = @project.roles.find(params[:id])
    authorize! :confirm, @role
    @role.confirm!
    respond_with @project, @role
  end
  
  def destroy
    @role = @project.roles.find(params[:id])
    authorize! :destroy, @role
    @role.destroy
    respond_with @project, @role
  end
  
  def load_project
    @project = Project.find(params[:project_id])
  end
end
