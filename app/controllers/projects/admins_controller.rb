class Projects::AdminsController < ApplicationController
  before_filter :authenticate_member!, :load_project
  respond_to :js, :html
  
  def index
    @admins = @project.admins
    authorize! :edit, @project
  end
  
  def create
    authorize! :edit, @project
    @admin = Member.find(params[:member_id])
    @project.admins << @admin
    MemberMailer.new_project_admin(@admin, @project).deliver!
  end
  
  def destroy
    authorize! :edit, @project
    @admin = Member.find(params[:id])
    @project.admins.delete(@admin)
  end
  
  def load_project
    @project = Project.find(params[:project_id])
  end
end
