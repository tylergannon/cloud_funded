class Pledge < ActiveRecord::Base  
  attr_accessible :amount, :investor, :project, :public, :post_to_fb, :public_viewable, :public_amount, :perk_id
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  belongs_to :perk
  
  validates :investor, presence: true
  validates :project, presence: true
  validates :amount, presence: true, numericality: true
  validates :perk, presence: true
  
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
