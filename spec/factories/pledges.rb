# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pledge do
    amount 1000
    association :project
    association :investor, factory: :member
    association :perk, factory: :projects_perk
  end
  
  factory :new_pledge, parent: :pledge do
    after(:create) do |pledge|
      pledge.workflow_state = 'not_pledged'
      pledge.save!
    end
  end
  
  factory :pledge_choose_payment_method, parent: :pledge do
    after(:create) do |pledge|
      pledge.workflow_state = 'choose_payment_method'
      pledge.save!
    end
  end
  
  factory :pledge_pay_by_cc, parent: :pledge do
    payment_method 'cc'
    after(:create) do |pledge|
      pledge.workflow_state = 'pay_by_cc'
      pledge.save!
    end
  end
end
