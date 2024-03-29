# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_transaction do
    transaction_id "MyString"
    amount 10000
    amount_refunded 0
    transaction_date {DateTime.now}
    description "MyString"
    disputed false
    failure_message "MyString"
    fee 2930
    paid true
    invoice "MyString"
    object_type "MyString"
    refunded false
    association :pledge
    
    after(:create) do |transaction|
      unless transaction.fee == (transaction.amount.to_f * 0.029 + 30).to_i
        transaction.update_attributes fee: (transaction.amount.to_f * 0.029 + 30).to_i
      end
    end
  end
end
