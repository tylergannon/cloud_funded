class AfterCreateProjectController < ApplicationController
  include Wicked::Wizard
  steps :share, :add_urls
  
  def show
    @project = Project.find(params[:project_id])

    render_wizard
  end
  
  def update
    
  end
end
