# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projects_perk, :class => 'Projects::Perk' do
    name "MyString"
    description "MyString"
    price 1
    quantity 1
    delivery_terms "MyString"
    association :project
  end
end
