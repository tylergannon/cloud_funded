class Projects::PledgeWizardController < ApplicationController
  include Wicked::Wizard
  
  steps :pledge, :pay, :share

  before_filter :authenticate_member!, :load_project
  
  def show
    authorize! :edit, @pledge
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
  
  def load_project
    @project = params[:project_id] ? 
                  Project.find(params[:project_id]) : 
                  current_member.project_application
    pledges = Pledge.where(project_id: @project.id, investor_id: current_member.id)
    @pledge = pledges.empty? ? pledges.create! : pledges.first
  end
end
