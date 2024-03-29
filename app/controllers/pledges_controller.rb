class PledgesController < ApplicationController
  respond_to :html
  before_filter :authenticate_member!, except: [:index, :show]
  before_filter :load_project
  before_filter :load_pledge, only: [:show, :edit, :update, :destroy]
  
  def index
    @pledges = @project.pledges
    respond_with @project, @pledges
  end

  def show
    unless @pledge
      redirect_to new_project_pledge_path(@project)
    else
      authorize! :read, @pledge
      respond_with @project, @pledge do |format|
        format.html {
          render action: 'show_my_pledge' unless params[:id]
        }
      end
    end
  end

  def new
    @pledge = Pledge.where(project_id: @project.id, investor_id: current_member.id).first ||
              Pledge.new
    respond_with @project, @pledge do |format|
      format.html {
        if @pledge.new_record?
          authorize! :create, @pledge
        else
          render action: :show
        end
      }
    end
  end

  def edit
    authorize! :edit, @pledge
    respond_with @project, @pledge
  end

  def create
    @pledge = @project.pledges.build({investor: current_member}.merge(params[:pledge]))
    authorize! :create, @pledge
    respond_with @project, @pledge do |format|
      format.html {
        if @pledge.valid?
          if @pledge.post_to_fb
            @pledge.fb_post_id = CloudFunded::Facebook::Actions.pledge_to_support project_url(@project), current_member.fb_token          
          end
          @pledge.save!
          redirect_to project_my_pledge_path(@project)
        else
          render action: :new
        end
      }
    end
  end

  def update
    authorize! :edit, @pledge
    @pledge.update_attributes(params[:pledge])
    respond_with @project, @pledge
  end

  def destroy
    authorize! :destroy, @pledge
    @pledge.destroy
    respond_with @project, @pledge
  end
  
  def load_project
    @project = Project.find(params[:project_id])
  end
  
  def load_pledge
    if params[:id]
      member = Member.find(params[:id])
      @pledge = @project.pledges.where(investor_id: member.id).first
    else
      @pledge = Pledge.my_pledge(current_member, @project)
    end
  end
end
