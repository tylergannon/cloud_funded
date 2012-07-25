class Projects::PerksController < ApplicationController
  respond_to :js, :json
  # load_and_authorize_resource :perk, :class => 'Projects::Perk', :through => :project, except: [:create]
  
  def create
    @project = Project.find(params[:project_id])
    @perk = @project.perks.build params[:perk]
    authorize! :create, @perk
    @perk.save
    respond_with @perk
  end
  
  def update
    @project = Project.find(params[:project_id])
    @perk = @project.perks.find(params[:id])
    authorize! :edit, @perk
    @perk.update_attributes params[:perk]
    respond_with @project, @perk do |format|
      format.json {
        render json: @perk.as_json
      }
    end
  end
end
