class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  has_and_belongs_to_many :followed_projects, class_name: 'Project' do
    def <<(project)
      super(project)
      Members::Updates::FollowUpdate.create member: project.owner, project: project, follower: proxy_association.owner
    end
  end

  has_and_belongs_to_many :administered_projects, class_name: 'Project', join_table: 'projects_admins'
  
  has_many :projects, foreign_key: :owner_id, dependent: :destroy do
    def live
      where(workflow_state: 'live')
    end
  end
  has_many :roles, class_name: 'Projects::Role' do
    def confirmed
      where(workflow_state: 'confirmed')
    end
  end
  has_many :transactions, dependent: :destroy
  has_many :pledges, inverse_of: :investor, foreign_key: 'investor_id' do
    def paid
      where(workflow_state: 'payment_received')
    end
  end
  
  has_many :open_graph_actions, class_name: 'OpenGraph::Action', dependent: :destroy
  
  belongs_to :twitter_login, class_name: 'Members::TwitterLogin', foreign_key: 'twitter_login_id'
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_id, :profile_pic, :profile,
                  :first_name, :last_name, :fb_token, :dwolla_id, :dwolla_auth_token, :twitter_login_id, :google_plus

  after_create do |member|
    Projects::Role.where(member_id: nil, email_address: member.email).update_all member_id: member.id
  end
  
  def like?(object)
    @like ||= !OpenGraph::Like.where(member_id: self.id, graph_object_type: object.class.name, graph_object_id: object.id).empty?
  end
  
  def funded?(project)
    pledges.map(&:project).include?(project)
  end
  
  def linked_to_dwolla?
    !dwolla_auth_token.blank?
  end
  
  def first_name=(name)
    super(name)
    self.full_name = "#{first_name} #{last_name}"
  end

  def last_name=(name)
    super(name)
    self.full_name = "#{first_name} #{last_name}"
  end
  
  def account_balance
    transactions.map(&:amount).sum
  end
  
  def project_application
    @project_application ||= projects.where("workflow_state <> 'live'").first || projects.create!
  end
  
  def email=(email)
    super(email)
    self.normalized_email = email.downcase
  end
  
  def full_name=(full_name)
    super(full_name)
    self.normalized_full_name = full_name.downcase
  end
  
  def pledge_for(project)
    pledges = Pledge.where(project_id: project.id, investor_id: self.id)
    pledges.empty? ? pledges.create! : pledges.first
  end
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  # attr_accessible :title, :body
end
