class Projects::WizardController < ApplicationController
  include Wicked::Wizard
  
  steps :information, :basics, :where, :more_about_you, :fund_raise, :preview, :submitted

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
    if respond_to?("submit_#{params[:id]}")
      send "submit_#{params[:id]}"
    else
      render_wizard(@project)
    end
  end
  
  def submit_preview
    if @project.valid?
      @project.submit!
    end
    render_wizard(@project)
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
  end
end
