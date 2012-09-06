class ProjectMailer < ActionMailer::Base
  layout 'mailer'
  default from: "new-projects-no-reply@cloudfunded.com"
  
  def new_project(project)
    @project = project
    member = @project.owner
    mail(to: "#{member.full_name} <#{member.email}>", subject: "CloudFunded: Your ", from: from_address)
  end
  
  def submitted_project(project)
    @project = project
    member = @project.owner
    mail(to: "#{member.full_name} <#{member.email}>", subject: "CloudFunded: New Project Added", from: from_address)
  end
  
  def from_address
    "CloudFunded <new-projects-no-reply@cloudfunded.com>"
  end
end
