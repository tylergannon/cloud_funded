class ProjectsMailer < ActionMailer::Base
  default from: "new-projects-no-reply@cloudfunded.com"
  
  def new_project(project)
    @project = project
    mail(to: "tgannon@gmail.com,david@cloudfunded.com", subject: "CloudFunded: New Project Added", from: from_address)
  end
  
  def from_address
    "new-projects-no-reply@cloudfunded.com"
  end
end
