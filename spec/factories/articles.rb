# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    body "MyText"
    published false
    published_at {Time.zone.now}
    association :author, factory: :member
  end
end
