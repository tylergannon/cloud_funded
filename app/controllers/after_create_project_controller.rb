class AfterCreateProjectController < ApplicationController
  include Wicked::Wizard
  steps :where, :share, :add_urls
  
  def show
    @project = Project.find(params[:project_id])

    render_wizard
  end
  
  def update
    @project = Project.find(params[:project_id])
    if params[:project]
      @project.update_attributes params[:project]
    end
    puts "*" * 80
    puts step
    if methods.include?(step)
      send(step)
    end
    render_wizard(@project)
  end
end
