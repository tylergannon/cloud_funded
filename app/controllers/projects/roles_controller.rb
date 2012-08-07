class Projects::RolesController < ApplicationController
  respond_to :js
  before_filter :authenticate_member!, :load_project
  
  def new
    authorize! :edit, @project
    @role = @project.roles.build
    @role.invited_by = current_member
    respond_with @project, @role
  end
  
  def index
    authorize! :edit, @project
    @roles = @project.roles
    
  end
  
  def create
    authorize! :edit, @project
    @role = @project.roles.build(params[:role])
    if @role.member
      @role.email_address = @role.member.email
    end
    @role.invited_by = current_member
    @member = Member.where(email: @role.email_address).first
    if @member
      @role.member = @member
    end
    @role.save
    respond_with @project, @role
  end
  
  def edit
    @role = @project.roles.find(params[:id])
    authorize! :edit, @role
    respond_with(@role,@project)
  end

  def update
    @role = @project.roles.find(params[:id])
    authorize! :edit, @role
    @role.update_attributes params[:role]
    respond_with(@role,@project)
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
