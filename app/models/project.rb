class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :description, :financial_goal, :name, :owner, :pledges, 
                  :completion_date, :image, :youtube_url, :website_url, 
                  :short_description, :address, :lat, :long, :post_to_fb,
                  :fb_post_id, :google_plus, :google_places, :facebook, 
                  :linkedin_profile, :linkedin_business, :yelp, :category_id, :tagline,
                  :about_your_product_image, :how_it_helps_image, :your_target_market_image, 
                  :history_image, :about_your_product, :how_it_helps, :your_target_market, :history
  
  belongs_to :owner, class_name: 'Member'
  belongs_to :category, class_name: 'Projects::Category'
  has_many :pledges
  has_many :articles
  has_many :perks
  
  default_value_for :post_to_fb, true
  default_value_for :published, false
  
  def published?; published; end
  
  S3_DEETS = {
    :styles => { large: "560x310", :medium => "300x190", :thumb => "100x100" },
    :storage => :s3,
    :s3_protocol => '',
    :bucket => ENV['AMAZON_S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '50gpJp/XEoaVGg4/M2JJk16AST5EefWSfWXTD9FH'
    }  
  }
  
  has_attached_file :image, S3_DEETS
  has_attached_file :about_your_product_image, S3_DEETS
  has_attached_file :how_it_helps_image, S3_DEETS
  has_attached_file :your_target_market_image, S3_DEETS
  has_attached_file :history_image, S3_DEETS
  
  # validates :category, presence: true
  # validates_attachment_presence :image
  # validates :description, length: {maximum: 500}
  # validates :financial_goal, numericality: {less_than_or_equal_to: 1000000}
  # validates :name, uniqueness: true
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
  
  def financial_goal=(something)
    if something.kind_of?(String)
      something = something.gsub(/\D/, '')
    end
    super(something)
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
