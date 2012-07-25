# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association :article
    association :member
    body "MyText that is long enough to pass vlaidation"
  end
end
