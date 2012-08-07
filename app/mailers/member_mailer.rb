class MemberMailer < ActionMailer::Base
  layout 'mailer'
  default from: "welcome-no-reply@cloudfunded.com"
  
  def new_member(member)
    @member = member
    mail(to: member.email, subject: "CloudFunded: New Project Added", from: from_address)
  end
  
  def confirm_role(role)
    @role = role
    mail(to: role.email_address, subject: "CloudFunded: Please confirm your role on #{role.project.name}", from: "CloudFunded <confirmations-no-reply@cloudfunded.com>")
  end
  
  def new_project(project)
    @project = project
    mail(to: "tgannon@gmail.com,david@cloudfunded.com", subject: "CloudFunded: New Project Added", from: "new-projects-no-reply@cloudfunded.com")
  end

  def from_address
    "welcome-no-reply@cloudfunded.com"
  end
end
