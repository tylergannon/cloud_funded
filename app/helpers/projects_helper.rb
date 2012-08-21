module ProjectsHelper
  def tweet_text(project)
    "Pledge support for #{project.name} on CloudFunded!"
  end
  
  def progress_bar(project)
    content_tag('div', '', class: 'progress') {
      content_tag('div', '', class: 'bar', style: 'width: ' + project.percent_complete.to_s + '%;')
    }.html_safe
  end
  
  def active_tab?(str, default=false)
    if params[:show] == str || (params[:show].blank? && default)
      {class: 'active'}
    else
      {}
    end
  end
end
