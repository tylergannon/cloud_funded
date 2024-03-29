class Project < ActiveRecord::Base
  extend FriendlyId
  include ActionView::Helpers::NumberHelper
  include Workflow
  
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    new_record? || name_changed?
  end
  
  attr_accessible :about_your_product, :about_your_product_image, :address, :category_id, :city, 
                  :completion_date, :county, :days, :description, :end_date, :end_date_string, :facebook, 
                  :fb_post_id, :financial_goal, :financial_goal_string, :google_places, :google_plus, 
                  :history, :history_image, :how_it_helps, :how_it_helps_image, :image, :information_text, 
                  :lat, :linkedin_business, :linkedin_profile, :long, :name, :owner, :perks_attributes, 
                  :pledges, :post_to_fb, :postal_code, :route, :short_description, :slug, :start_date, 
                  :start_date_string, :state, :street_number, :tagline, :visible, :website_url, :yelp, 
                  :your_target_market, :your_target_market_image, :youtube_url, :new_project_sent_at
  
  belongs_to :owner, class_name: 'Member'
  belongs_to :category, class_name: 'Projects::Category'
  has_many :attachments, as: :attachable, dependent: :destroy
  has_and_belongs_to_many :followers, class_name: 'Member' do
    def <<(member)
      super(member)
      Members::Updates::FollowUpdate.create member: proxy_association.owner.owner, project: proxy_association.owner, follower: member
    end
  end
  
  has_and_belongs_to_many :admins, class_name: 'Member', join_table: 'projects_admins'
  
  has_many :roles, class_name: 'Projects::Role', dependent: :destroy do
    def confirmed
      where(workflow_state: 'confirmed')
    end
  end
  
  has_many :pledges, dependent: :destroy do
    def paid
      where(workflow_state: 'paid')
    end
  end
  
  has_many :articles, dependent: :destroy do
    def published
      where(workflow_state: 'published')
    end
  end
  
  has_many :perks, class_name: 'Projects::Perk', dependent: :destroy
  
  accepts_nested_attributes_for :perks              
  
  monetize :financial_goal_cents
  
  DEFAULT_FUNDRAISE_LENGTH = 100
  
  default_value_for :post_to_fb, true
  default_value_for :published, false
  default_value_for(:start_date) {Date.today}
  default_value_for(:end_date) {(Date.today + DEFAULT_FUNDRAISE_LENGTH)}
  default_value_for(:visible, true)
  
  before_create do |project|
    project.perks.build price: 10
    project.perks.build price: 100
    project.perks.build price: 1000
  end
  
  def published?; published; end
  
  S3_DEETS = {
    :styles => { large: "560x310", :medium => "300x190", :thumb => "100x100" },  
  }
  
  has_attached_file :image, S3_DEETS.merge(AppConfig.paperclip_storage)
  has_attached_file :about_your_product_image, S3_DEETS.merge(AppConfig.paperclip_storage)
  has_attached_file :how_it_helps_image, S3_DEETS.merge(AppConfig.paperclip_storage)
  has_attached_file :your_target_market_image, S3_DEETS.merge(AppConfig.paperclip_storage)
  has_attached_file :history_image, S3_DEETS.merge(AppConfig.paperclip_storage)
  
  validates :category, presence: true, :if => lambda {|project| !project.new?}
  validates_attachment :image, presence: true, :if => lambda {|project| !project.new?}
  validates :tagline, presence: true, :if => lambda {|project| !project.new?}
  validates :short_description, length: {maximum: 500}, :if => lambda {|project| !project.new?}
  validates :name, uniqueness: true, :if => lambda {|project| !project.new?}
  validates :owner, presence: true
  # validates :website_url, presence: true
  validates :address, presence: true, :if => lambda {|project| !project.new?}
  # validates :lat, presence: true
  # validates :long, presence: true
  validates :financial_goal, presence: true, :if => lambda {|project| !project.new?}
  
  validate do |project|
    unless project.new?
      if project.financial_goal_cents && (project.financial_goal_cents > 1000000 * 100)
        project.errors.add :financial_goal, "Should be less than 1 million."
      end
    end
  end
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :slug, 
              presence: true, 
              uniqueness: true, 
              format: {
                with: /^[a-zA-Z0-9\-]+$/, 
                message: 'Must be letters, numbers or dashes'
              },
              :if => lambda {|project| !project.new?}
  

  workflow do
    state :new do
      event :preview, :transitions_to => :previewing
    end
    
    state :previewing do
      event :fail_validation, :transitions_to => :new
      event :submit, :transitions_to => :being_reviewed
    end
    
    state :being_reviewed do
      event :accept, :transitions_to => :live
      event :reject, :transitions_to => :rejected
    end
    
    state :live
    state :rejected
  end
  
  def accept
    begin
      OpenGraph::Launch.create member: self.owner, graph_object: self
    rescue Exception => e
      logger.error("Error creating launch action at FB: #{e.message}\n#{e.backtrace}")
    end
  end
  
  def submitted?
    live? || rejected? || being_reviewed?
  end
  
  def submit
    ProjectMailer.submitted_project(self).deliver
    # MemberMailer.new_member(member).deliver
  end

  def youtube_url=(url)
    super(url.gsub(/watch\?v=/, 'embed/'))
  end
    
  def amount_pledged
    pledges.paid.empty? ? Money.us_dollar(0) : pledges.paid.map(&:amount).sum
  end
  
  def amount_remaining
    financial_goal - amount_pledged
  end
  
  def percent_complete
    unless amount_pledged && financial_goal && financial_goal > 0
      0
    else
      ((amount_pledged / financial_goal) * 100).to_i
    end
  end
  
  def financial_goal_string=(something)
    if something.kind_of?(String)
      something = something.gsub(/\D/, '').to_i
    end
    self.financial_goal = something
  end
  
  def financial_goal_string
    financial_goal.format(symbol: false, thousands_separator: ',', no_cents: true) if financial_goal
  end
  
  def days
    (end_date - start_date).to_i if start_date && end_date
  end
  
  def days=(a)
  end
  
  [:start_date=, :end_date=].each do |meth|
    define_method meth do |d|
      if d.kind_of?(String) && match = d.match(/^(\d{2})\/(\d{2})\/(\d{4})/)
        super Date.parse("#{match[3]}-#{match[1]}-#{match[2]}")
      else
        super(d)
      end
    end
  end
    
  def as_json(*args)
    val = {}
    [:image, :about_your_product_image, :how_it_helps_image, :your_target_market_image, 
    :history_image].each do |image|
      val[image] = {
        url_original: self.send(image).url(:original),
        url_large: self.send(image).url(:large)
      }
    end
    val
  end
end
