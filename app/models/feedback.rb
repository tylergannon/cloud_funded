class Feedback < ActiveRecord::Base
  attr_accessible :about_page, :body, :member_id, :subject, :member
  
  belongs_to :member
end
