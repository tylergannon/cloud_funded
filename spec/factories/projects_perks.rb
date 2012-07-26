# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projects_perk, :class => 'Projects::Perk' do
    name "MyString"
    description "MyString"
    price_cents 100
    quantity 1
    delivery_terms "MyString"
    association :project
  end
  
  factory :baby_elephant_perk, parent: :projects_perk do
    name "Baby Elephant"
    description "Name is Donkey."
    price_cents 30000
    image {fixture_file_upload('spec/support/baby_elephant.jpeg')}
  end

  factory :unicorn_perk, parent: :projects_perk do
    name "Unicorn"
    description "Name is also Donkey."
    price_cents 3000000
    image {fixture_file_upload('spec/support/unicorn.gif')}
  end

  factory :manticore_perk, parent: :projects_perk do
    name "Manticore"
    description "Name is also Donkey."
    price_cents 30000000
    image {fixture_file_upload('spec/support/manticore.jpeg')}
  end
end
