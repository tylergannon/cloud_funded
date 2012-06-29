# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
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
    image Rack::Test::UploadedFile.new('spec/support/onebit_33.png', 'image/png')
  end
end
