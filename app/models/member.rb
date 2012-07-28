class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  has_many :projects, foreign_key: :owner_id, dependent: :destroy do
    def live
      where(workflow_state: 'live')
    end
  end
  has_many :roles, class_name: 'Projects::Role'
  has_many :transactions, dependent: :destroy
  has_many :pledges, inverse_of: :investor, foreign_key: 'investor_id' do
    def paid
      where(workflow_state: 'payment_received')
    end
  end
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_id, :profile_pic, :profile,
                  :first_name, :last_name, :fb_token, :dwolla_id, :dwolla_auth_token

  after_create do |member|
    Projects::Role.where(member_id: nil, email_address: member.email).update_all member_id: member.id
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  def account_balance
    transactions.map(&:amount).sum
  end
  
  def project_application
    @project_application ||= projects.where("workflow_state <> 'live'").first || projects.create!
  end
  
  def pledge_for(project)
    pledges = Pledge.where(project_id: project.id, investor_id: self.id)
    pledges.empty? ? pledges.create! : pledges.first
  end
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  # attr_accessible :title, :body
end
