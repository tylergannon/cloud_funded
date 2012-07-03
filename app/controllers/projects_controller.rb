class ProjectsController < ApplicationController
  before_filter :authenticate_member!, except: [:index, :show]
  respond_to :html, :json
  
  # GET /projects
  # GET /projects.json
  def index
    if params[:show] == "mine"
      @projects = current_member.projects
    else
      @projects = Project.all
    end
    
    respond_to do |format|
      format.html {
        if params[:show] == "mine"
          render action: :my_projects
        end
      }
      format.json { render json: @projects }
    end
  end
  
  def share
    @project = Project.find(params[:id])
    respond_with @project
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @title = "#{@project.name} on CloudFunded"
    if member_signed_in?
      @my_pledge = Pledge.where(investor_id: current_member.id, project_id: @project.id).first
    end
    authorize! :read, @project

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end
  
  def publicize
    @project = Project.find(params[:id])
    @title = "Publicize || " + @project.name
    respond_with @project
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new(owner: current_member)
    authorize! :create, @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    authorize! :edit, @project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    @project.owner = current_member
    authorize! :create, @project

    respond_to do |format|
      if @project.valid?
        if @project.post_to_fb
          @project.fb_post_id = CloudFunded::Facebook::Actions.create_project project_url(@project), current_member.fb_token          
        end
        ProjectsMailer.new_project(@project).deliver
        @project.save!
        format.html { redirect_to project_wizard_path(@project), notice: 'Congratulations!  Your project is listed.  Now you can share it with others.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    authorize! :edit, @project

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    authorize! :destroy, @project

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
