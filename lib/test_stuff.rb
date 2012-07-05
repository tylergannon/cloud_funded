member = Member.where(email: 'tgannon@gmail.com').first
ACCESS_TOKEN = member.dwolla_auth_token
user = Dwolla::User.me(ACCESS_TOKEN).fetch
user.contacts(:search => "CloudFunded")

"Invalid account PIN"
"Insufficient funds."


begin
  user.send_money_to "812-608-2017", 0.01, 7464, 'dwolla', 'Test'
rescue Exception => e
  puts e.inspect
  puts
  puts e.message
end

begin
  user.send_money_to "812-608-2017", 1000000, 7465, 'dwolla', 'Test'
rescue Exception => e
  puts e.inspect
  puts
  puts e.message
end

