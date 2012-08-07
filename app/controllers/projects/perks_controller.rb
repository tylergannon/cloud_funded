class Projects::PerksController < ApplicationController
  respond_to :js, :json, :html
  before_filter :load_project
  
  def index
    authorize! :edit, @project
    @perks = @project.perks
    
     respond_with @project, @perk do |format|
      format.html {
        render layout: 'edit_projects'
      }
    end
  end
  
  def edit
    @perk = @project.perks.find params[:id]
    authorize! :edit, @perk
    respond_with @project, @perk
  end
  
  def sort
    authorize! :edit, @project
    params[:order].each_with_index do |id, index|
      perk = @project.perks.select{|t| t.id==id.to_i}.first
      perk.sort_order = index
      perk.save! validate: false
    end
    render text: ''
  end
  
  def create
    @perk = @project.perks.build params[:perk]
    authorize! :edit, @perk
    authorize! :create, @perk
    @perk.save
    respond_with @project, @perk
  end
  
  def show
    @perk = @project.perks.find(params[:id])
    authorize! :edit, @perk
  end
  
  def update
    @perk = @project.perks.find(params[:id])
    authorize! :edit, @perk
    @perk.update_attributes params[:perk]
    unless @perk.valid?
      puts @perk.errors.inspect
    end
    respond_with @project, @perk do |format|
      format.html {
        redirect_to project_perks_path(@project)
      }
      format.json {
        render json: @perk.as_json
      }
    end
  end
  
  def destroy
    @perk = @project.perks.find(params[:id])
    authorize! :destroy, @perk
    @perk.destroy

    respond_with @project, @perk do |format|
      format.html {
        redirect_to project_perks_path(@project)
      }
      format.json {
        render json: @perk.as_json
      }
    end
  end
  
  def load_project
    authenticate_member!
    @project = Project.find(params[:project_id])
  end
end
