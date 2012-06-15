class Pledge < ActiveRecord::Base
  attr_accessible :amount, :investor, :project
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  
  validates :investor, presence: true
  validates :project, presence: true
  
  def self.my_pledge(member, project)
    where(investor_id: member.id, project_id: project.id).first
  end
end
