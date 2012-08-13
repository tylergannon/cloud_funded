# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :update, :class => 'Members::Updates::Update' do
    type 'Members::Updates::Update'
    read false
    association :member
    object1 {FactoryGirl.create :member}
    object2 {FactoryGirl.create :project}
  end
end
