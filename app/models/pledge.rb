class Pledge < ActiveRecord::Base  
  attr_accessible :amount, :investor, :project, :public, :post_to_fb, :public_viewable, :public_amount
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  
  validates :investor, presence: true
  validates :project, presence: true
  
  default_value_for :public_viewable, true
  default_value_for :public_amount, true
  default_value_for :post_to_fb, true
  
  def investor_name
    investor.friendly_id
  end
  
  def to_param
    investor_name
  end
  
  def self.my_pledge(member, project)
    where(investor_id: member.id, project_id: project.id).first
  end
end
