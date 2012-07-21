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
    association :category, factory: :projects_category

    # image {fixture_file_upload('spec/support/onebit_33.png')}
  end
  
  factory :completed_project, parent: :project do
    lat 38.455489
    long -122.755758
    street_number "2131"
    address "2131 Crosspoint Ave, Santa Rosa, CA 95403, USA"
    route "Crosspoint Ave"
    city "Santa Rosa"
    county "Sonoma"
    state "CA"
    
    
    
  end
end
