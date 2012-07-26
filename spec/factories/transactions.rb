 # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    association :member
    amount 9.99
    # amount_refunded 0
    type 'DwollaTransaction'
    transaction_id "MyString"
  end
end
