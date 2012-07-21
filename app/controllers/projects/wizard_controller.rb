class Projects::WizardController < ApplicationController
  include Wicked::Wizard
  
  steps :information, :basics, :where, :more_about_you, :fund_raise, :preview, :submit

  before_filter :authenticate_member!, :load_project
  
  def show
    authorize! :edit, @project
    render_wizard
  end
  
  def update
    authorize! :edit, @project
    if params[:project]
      @project.update_attributes params[:project]
    end
    render_wizard(@project)
  end
  
  def load_project
    @project = params[:project_id] ? 
                  Project.find(params[:project_id]) : 
                  current_member.project_application
  end
end
