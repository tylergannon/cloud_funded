# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projects_category, :class => 'Projects::Category' do
    name 'Retail'
    desription "MyString"
  end
end
