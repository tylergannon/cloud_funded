class Transaction < ActiveRecord::Base
  attr_accessible :amount, :amount_refunded, :description, :disputed, :failure_message, :fee, :invoice, :object_type, :refunded, :transaction_id, :transaction_date, :member, :pledge, :paid
  belongs_to :member
  belongs_to :pledge
  
  validates :member, presence: true
  validates :amount, presence: true, numericality: true
  validates :type, presence: true
  
  default_scope order('id DESC')
  
  def pledge=(p)
    self.member = p.investor
    super(p)
  end

  def self.from_stripe_charge(charge)
    trans = Transaction.new \
      transaction_id: charge.id,
      amount: charge.amount,
      amount_refunded: charge.amount_refunded,
      transaction_date: DateTime.strptime(charge.created.to_s, '%s'),
      description: charge.description,
      disputed: charge.disputed,
      failure_message: charge.failure_message,
      fee: charge.fee,
      invoice: charge.invoice,
      object_type: charge.object,
      paid: charge.paid,
      refunded: charge.refunded
    trans.type = 'StripeTransaction'
    trans
  end
end
