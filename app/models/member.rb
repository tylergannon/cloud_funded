class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  has_many :projects, foreign_key: :owner_id
  has_many :transactions
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_id, :profile_pic, :profile,
                  :first_name, :last_name, :fb_token, :dwolla_id, :dwolla_auth_token
  
  def full_name
    "#{first_name} #{last_name}"
  end
  def account_balance
    transactions.map(&:amount).sum
  end
  
  def project_application
    @project_application ||= projects.where(published: false).first || projects.create!
  end
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  # attr_accessible :title, :body
end
