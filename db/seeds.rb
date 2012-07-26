# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


puts "I'm going to create the admin member."
Member.where(email: 'transactions@cloudfunded.com').destroy_all
cf = Member.new email: 'transactions@cloudfunded.com', password: 'onthebooks1', password_confirmation: 'onthebooks1'
cf.admin = true
cf.first_name = 'CloudFunded'
cf.last_name = 'Admin'
cf.skip_confirmation!
cf.save!

if Projects::Category.empty?
  FactoryGirl.create :projects_category
end

3.times {
  FactoryGirl.create :live_project, owner: cf
}