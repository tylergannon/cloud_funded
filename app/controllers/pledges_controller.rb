class PledgesController < ApplicationController
  respond_to :html
  before_filter :authenticate_member!, except: [:index, :show]
  before_filter :load_project
  
  def index
    @pledges = @project.pledges
    respond_with @project, @pledges
  end

  def show
    @pledge = @project.pledges.find(params[:id])
    authorize! :read, @pledge
    respond_with @project, @pledge
  end

  def new
    @pledge = @project.pledges.build(investor: current_member)
    authorize! :create, @pledge
    respond_with @project, @pledge
  end

  def edit
    @pledge = Pledge.find(params[:id])
    authorize! :edit, @pledge
    respond_with @project, @pledge
  end

  def create
    @pledge = @project.pledges.create({investor: current_member}.merge(params[:pledge]))
    authorize! :create, @pledge
    respond_with @project, @pledge do |format|
      format.html {
        if @pledge.valid?
          redirect_to @project
        end
      }
    end
  end

  def update
    @pledge = @project.pledges.find(params[:id])
    authorize! :edit, @pledge
    @pledge.update_attributes(params[:pledge])
    respond_with @project, @pledge
  end

  def destroy
    @pledge = @project.pledges.find(params[:id])
    authorize! :destroy, @pledge
    @pledge.destroy
    respond_with @project, @pledge
  end
  
  def load_project
    @project = Project.find(params[:project_id])
  end
end
