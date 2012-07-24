class Projects::PledgeWizardController < ApplicationController
  include Wicked::Wizard
  
  steps :pledge, :pay, :share

  before_filter :authenticate_member!, :load_project
  
  def show
    authorize! :edit, @project
    render_wizard
  end
  
  def update
    authorize! :edit, @pledge
    if params[:pledge]
      @pledge.update_attributes params[:pledge]
    end
    if respond_to?("submit_#{step}")
      send "submit_#{step}"
    else
      render_wizard(@pledge)
    end
  end
  
  def submit_pledge
    if @pledge.valid?
      @pledge.pledge!
    end
    render_wizard(@pledge)
  end
  
  def submit_fund_raise
    @project.preview!
    @project.fail_validation! unless ok = @project.valid?

    respond_with @project do |format|
      format.html {
        if ok
          render_wizard(@project)
        else
          render :fund_raise
        end
      }
    end
  end
  
  def load_project
    @project = params[:project_id] ? 
                  Project.find(params[:project_id]) : 
                  current_member.project_application
    pledges = Pledge.where(project_id: @project.id, investor_id: current_member.id)
    @pledge = pledges.empty? ? pledges.create! : pledges.first
  end
end
