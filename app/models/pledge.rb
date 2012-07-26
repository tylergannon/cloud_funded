class Pledge < ActiveRecord::Base  
  include Workflow
  attr_accessible :amount, :investor, :project, :public, :post_to_fb, :public_viewable, :public_amount, :perk_id, :payment_method
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  belongs_to :perk, class_name: 'Projects::Perk'
  has_many :stripe_transactions, dependent: :destroy
  
  validates :investor, presence: true
  validates :project, presence: true
  validates :amount, presence: true, numericality: true, :if => lambda {|pledge| !pledge.new?}
  validates :perk, presence: true, :if => lambda {|pledge| !pledge.new?}
  
  validate do |pledge|
    if perk && pledge.amount < perk.price
      pledge.errors.add :amount, "Pledge amount must be at least the price of the perk."
    end
    
    if perk && perk.project != pledge.project
      raise "Big trouble"
    end
    
    if pay_by_cc? && latest_transaction && !latest_transaction.paid
      pledge.errors.add :payment_error, "There was a problem processing your payment."
    end
  end
  
  after_create do |pledge|
    pledge.created!
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
  
  def latest_transaction
    stripe_transactions.first
  end
  
  workflow do
    state :new do
      event :created, transitions_to: :not_pledged
    end
    
    state :not_pledged do
      event :pledge, transitions_to: :choose_payment_method
    end
    
    state :choose_payment_method do
      event :choose_pay_by_dwolla, transitions_to: :dwolla
      event :choose_pay_by_cc, transitions_to: :pay_by_cc
      event :cancel, transitions_to: :cancelled
    end
    
    state :pay_by_cc do
      event :cc_payment_succeeded, transitions_to: :payment_received
    end
    
    state :dwolla do
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
