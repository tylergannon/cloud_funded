# Read about factories at https://github.com/thoughtbot/factory_girl

include ActionDispatch::TestProcess
FactoryGirl.define do
  extend ActionDispatch::TestProcess
  sequence :name do |i|
    "nicebax#{i}#{rand}"
  end
    
  factory :project do
    
    name
    description "MyText"
    financial_goal 9.99
    address "1931 Coolio Ave, Oakland, Ca"
    lat 123.45
    long 12.12
    website_url 'http://www.google.com/'
    association :owner, factory: :member

    image {fixture_file_upload('spec/support/onebit_33.png')}
  end
end
