# Read about factories at https://github.com/thoughtbot/factory_girl

include ActionDispatch::TestProcess
FactoryGirl.define do
  extend ActionDispatch::TestProcess
  sequence :name do |i|
    "Magical Mystery Tour#{i}"
  end
    
  factory :project do
    name
    description "."
    financial_goal 9.99
    address "1931 Coolio Ave, Oakland, Ca"
    tagline "It's coming to take you away."
    short_description "Pretty Cool"
    lat 123.45
    long 12.12
    website_url 'http://www.thebeatles.com/'
    association :owner, factory: :member
    category {Projects::Category.first || FactoryGirl.create(:projects_category)}
  end
  
  factory :live_project, parent: :project do
    lat 38.455489
    long -122.755758
    street_number "2131"
    address "2131 Crosspoint Ave, Santa Rosa, CA 95403, USA"
    route "Crosspoint Ave"
    city "Santa Rosa"
    county "Sonoma"
    state "CA"
    postal_code "95403"
    image {fixture_file_upload('spec/support/onebit_33.png')}
    workflow_state 'live'
  end
  
  factory :full_project, parent: :live_project do
    image {fixture_file_upload('spec/support/mystery_tour.jpeg')}
    workflow_state 'live'
    after(:create) do |project|
      Projects::Perk.where(name: nil).destroy_all
      project.perks.map(&:destroy)
      project.perks.clear
      project.perks << FactoryGirl.create( :baby_elephant_perk, project: project)
      project.perks << FactoryGirl.create( :unicorn_perk, project: project)
      project.perks << FactoryGirl.create( :manticore_perk, project: project)
    end
  end
  
end

