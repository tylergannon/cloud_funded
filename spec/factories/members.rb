# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |i|
    "nicebax#{rand}#{i}@tylergannon.me"
  end
  factory :member do
    first_name 'Niceguy'
    last_name 'Grouchysometimesthough'
    email
    password "yt*k*$GY$-ULKf3qy$O"
    password_confirmation "yt*k*$GY$-ULKf3qy$O"
    
    before_create { |member|
      member.skip_confirmation!
    }
  end
end
