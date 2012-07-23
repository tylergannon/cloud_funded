class Pledge < ActiveRecord::Base  
  include Workflow
  attr_accessible :amount, :investor, :project, :public, :post_to_fb, :public_viewable, :public_amount, :perk_id
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  belongs_to :perk, class_name: 'Projects::Perk'
  
  validates :investor, presence: true
  validates :project, presence: true
  validates :amount, presence: true, numericality: true
  validates :perk, presence: true
  
  validate do |pledge|
    if perk && pledge.amount < perk.price
      pledge.errors.add :amount, "Pledge amount must be at least the price of the perk."
    end
  end
  
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
  
  workflow do
    state :new do
      event :send_payment_request, transitions_to: :setting_up_dwolla
      event :member_pay, transitions_to: :payment_received
      event :cancel, transitions_to: :cancelled
    end
    state :setting_up_dwolla do
      event :finished_dwolla_setup, transitions_to: :payment_received
      event :cancel, transitions_to: :cancelled
    end
    state :payment_received do
      event :refund, transitions_to: :refund_pending
      event :project_fail, transitions_to: :refund_pending
      event :project_success, transitions_to: :completed
    end
    state :refund_pending do
      event :refund, transitions_to: :refunded
    end

    state :cancelled
    state :refunded
    state :completed
  end
end
