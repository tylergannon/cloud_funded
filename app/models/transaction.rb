class Transaction < ActiveRecord::Base
  attr_accessible :amount, :member_id, :transaction_id, :member
  belongs_to :member
end
