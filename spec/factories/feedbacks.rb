# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    subject "MyString"
    body "MyText that is long enough to pass validation"
    about_page "MyString"
    association :member
  end
end
