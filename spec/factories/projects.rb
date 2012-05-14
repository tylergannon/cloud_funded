# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "MyString"
    description "MyText"
    financial_goal "9.99"
    association :owner, factory: :member
  end
end
