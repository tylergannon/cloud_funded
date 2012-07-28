require 'securerandom'

class Projects::Role < ActiveRecord::Base
  include Workflow
  attr_accessible :email_address, :member_id, :ordinal, :project_id, :tagline, :name, :ordinal
  belongs_to :member
  belongs_to :invited_by, class_name: 'Member'
  belongs_to :project
  validates :email_address, presence: true
  validates :project, presence: true
  validates :name, presence: true
  validates :email_address, presence: true
  validates :invited_by, presence: true
  
  before_create do |role|
    role.confirmation_token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
  end
  after_create do |role|
    MemberMailer.confirm_role(role).deliver!
  end
  
  default_scope order(:ordinal)
  
  workflow do
    state :unconfirmed do
      event :confirm, transitions_to: :confirmed
    end
    
    state :confirmed
  end
end
