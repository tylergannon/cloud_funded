 # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    association :member
    amount 9.99
    transaction_id "MyString"
  end
end
