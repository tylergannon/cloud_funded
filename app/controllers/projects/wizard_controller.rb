class Projects::WizardController < ApplicationController
  include Wicked::Wizard
  
  steps :information, :basics, :where, :more_about_you, :fund_raise, :preview, :submit

  before_filter :authenticate_member!, :load_project
  
  def show
    render_wizard
  end
  
  def update
    if params[:project]
      @project.update_attributes params[:project]
    end
    if methods.include?(step)
      send(step)
    end
    render_wizard(@project)
  end
  
  def load_project
    @project = current_member.project_application
  end
end
