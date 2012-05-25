# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    body "MyText"
    published_at "2012-05-25 10:08:42"
  end
end
