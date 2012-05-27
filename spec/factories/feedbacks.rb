# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    subject "MyString"
    body "MyText"
    member_id 1
    about_page "MyString"
  end
end
