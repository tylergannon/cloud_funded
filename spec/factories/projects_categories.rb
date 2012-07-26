# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projects_category, :class => 'Projects::Category' do
    name "MyString"
    desription "MyString"
  end
end
