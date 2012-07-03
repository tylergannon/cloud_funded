class MemberMailer < ActionMailer::Base
  default from: "welcome-no-reply@cloudfunded.com"
  
  def new_member(member)
    @member = member
    mail(to: member.email, subject: "CloudFunded: New Project Added", from: from_address)
  end
  
  def from_address
    "welcome-no-reply@cloudfunded.com"
  end
end
