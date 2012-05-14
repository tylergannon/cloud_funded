# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |i|
    "nicebax#{i}@tylergannon.me"
  end
  factory :member do
    email
    password "yt*k*$GY$-ULKf3qy$O"
    password_confirmation "yt*k*$GY$-ULKf3qy$O"
    
    before_create { |member|
      member.skip_confirmation!
    }
  end
end
