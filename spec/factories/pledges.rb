# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pledge do
    amount 10
    association :project
    association :investor, factory: :member
    # association :perk, factory: :projects_perk
    after(:build) do |pledge|
      pledge.perk = pledge.project.perks[0]
    end
  end
end
