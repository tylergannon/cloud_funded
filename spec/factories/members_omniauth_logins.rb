# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :members_omniauth_login, :class => 'Members::OmniauthLogin' do
    type ""
    token "MyString"
    user_id "MyString"
    profile_url "MyString"
    profile_pic "MyString"
    member_id 1
  end
  
  factory :twitter_login, :class => 'Members::TwitterLogin' do
    token "MyString"
    name "Tyler Gannon"
    user_id "MyString"
    location 'Oakland, Ca'
    profile_url "MyString"
    profile_pic "MyString"
    association :member
  end
end
