class Pledge < ActiveRecord::Base  
  include Workflow
  attr_accessible :amount, :investor, :project, :public, :post_to_fb, :public_viewable, :public_amount, :perk_id, :payment_method
  belongs_to :investor, class_name: 'Member'
  belongs_to :project
  belongs_to :perk, class_name: 'Projects::Perk'
  has_many :transactions, dependent: :destroy
  
  validates :investor, presence: true
  validates :project, presence: true
  validates :amount, presence: true, numericality: true, :if => lambda {|pledge| !pledge.new?}
  validates :perk, presence: true, :if => lambda {|pledge| !pledge.new?}
  
  monetize :amount_cents
  
  validate do |pledge|
    if perk && pledge.amount < perk.price
      pledge.errors.add :amount, "Pledge amount must be at least the price of the perk."
    end
    
    if perk && perk.project != pledge.project
      raise "Big trouble"
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
    transactions.first
  end
  
  workflow do
    state :new do
      event :created, transitions_to: :unpaid
    end
    
    state :unpaid do
      event :pay_by_cc, transitions_to: :paid
      event :pay_by_dwolla, transitions_to: :paid
    end
    
    state :paid
  end
end
