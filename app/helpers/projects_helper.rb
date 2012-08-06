module ProjectsHelper
  def tweet_text(project)
    "Pledge support for #{project.name} on CloudFunded!"
  end
  
  def active_tab?(str, default=false)
    if params[:show] == str || (params[:show].blank? && default)
      {class: 'active'}
    else
      {}
    end
  end
end
