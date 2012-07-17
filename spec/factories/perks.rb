# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :perk do
    name "MyString"
    description "MyString"
    price 1
    quantity 1
    delivery_terms "MyString"
  end
end
