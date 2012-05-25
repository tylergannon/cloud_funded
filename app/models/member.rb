class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_id, :profile_pic, :profile,
                  :first_name, :last_name
  
  def full_name
    "#{first_name} #{last_name}"
  end
  # attr_accessible :title, :body
end
