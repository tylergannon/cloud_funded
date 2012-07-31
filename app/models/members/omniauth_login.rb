class Members::OmniauthLogin < ActiveRecord::Base
  attr_accessible :member_id, :profile_pic, :profile_url, :token, :type, :user_id, :member, :location, :name, :nickname
end
