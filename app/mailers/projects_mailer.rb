class ProjectsMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def new_project(project)
    @project = project
    mail(to: "tgannon@gmail.com,david@cloudfunded.com", subject: "CloudFunded: New Project Added", from: from_address)
  end
  
  def from_address
    if Rails.env.production?
      "project_admin@cloudfunded.com"
    else
      "othertg@gmail.com"
    end
  end
end
