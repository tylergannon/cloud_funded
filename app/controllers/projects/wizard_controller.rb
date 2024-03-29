class Projects::WizardController < ApplicationController
  include Wicked::Wizard
  
  steps :information, :basics, :where, :more_about_you, :fund_raise, :preview, :submitted

  before_filter :authenticate_member!, :load_project
  
  def show
    authorize! :edit, @project
    case step
    when :preview
      @project.preview! unless @project.previewing?
      unless @project.valid?
        @project.fail_validation!
        flash[:alert] = ("We haven't collected enough information to show you a preview just yet!<br/>" + 
        @project.errors.messages.map{|key, err| "#{key.to_s.titleize} #{err.join(', ')}"}.join("<br/>")).html_safe
        redirect_to wizard_path(previous_step)
        return
      end
    end
    @project.valid?
    render_wizard
  end
  
  def update
    authorize! :edit, @project
    if params[:project]
      @project.update_attributes params[:project]
    end
    
    if step == :basics
      if !@project.name.blank? && @project.new_project_sent_at.nil?
        ProjectMailer.new_project(@project).deliver!
        @project.update_attributes new_project_sent_at: DateTime.now
      end
    end
    
    puts @project.errors.inspect unless @project.valid?
    if respond_to?("submit_#{params[:id]}")
      send "submit_#{params[:id]}"
    else
      render_wizard(@project)
    end
  end
  
  def submit_preview
    if @project.valid?
      unless @project.submitted?
        @project.submit!
        @project.accept!
      end
    end
    render_wizard(@project)
  end
  
  def submit_fund_raise
    @project.preview! unless @project.submitted?
    @project.fail_validation! unless ok = @project.valid? || @project.submitted?
    unless @project.valid?
      puts @project.errors.inspect
    end

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
