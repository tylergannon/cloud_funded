class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :description, :financial_goal, :name, :owner, :pledges, 
                  :completion_date, :image, :youtube_url, :website_url, 
                  :short_description, :address, :lat, :long, :post_to_fb,
                  :fb_post_id, :google_plus, :google_places, :facebook, 
                  :linkedin_profile, :linkedin_business, :yelp
  
  belongs_to :owner, class_name: 'Member'
  has_many :pledges
  
  default_value_for :post_to_fb, true
  
  has_attached_file :image,
    :styles => { :medium => "300x190", :thumb => "100x100" },
    :storage => :s3,
    :bucket => 'cloud_funded',
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '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'
    }  
  
  validates_attachment_presence :image
  validates :description, length: {maximum: 500}
  validates :financial_goal, numericality: {less_than_or_equal_to: 1000000}
  validates :name, uniqueness: true
  validates :owner, presence: true
  # validates :website_url, presence: true
  # validates :address, presence: true
  # validates :lat, presence: true
  # validates :long, presence: true
  
  def youtube_url=(url)
    super(url.gsub(/watch\?v=/, 'embed/'))
  end
  
  def amount_pledged
    pledges.map(&:amount).sum
  end
  
  def amount_remaining
    financial_goal - amount_pledged
  end
  
  def percent_complete
    amount_pledged * 100 / financial_goal
  end
end
