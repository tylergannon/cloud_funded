# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    attachable_id 123
    attachable_type 'Article'
    title "MyString"
    image {fixture_file_upload('spec/support/onebit_33.png')}
  end
end
