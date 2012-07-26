# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_transaction do
    stripe_transaction_id "MyString"
    amount 1
    amount_refunded 1
    transaction_date "2012-07-25 19:29:49"
    description "MyString"
    disputed false
    failure_message "MyString"
    fee 1
    invoice "MyString"
    object_type "MyString"
    refunded false
  end
end
