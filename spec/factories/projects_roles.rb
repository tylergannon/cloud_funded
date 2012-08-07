# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :ordinal do |i|
    i
  end
  
  factory :projects_role, :class => 'Projects::Role' do
    name 'Supreme Chancellor'
    association :project
    member nil
    association :invited_by, factory: :member
    confirmation_token nil
    email_address "somebody@somewhere.com"
    workflow_state "MyString"
    ordinal
  end
end
