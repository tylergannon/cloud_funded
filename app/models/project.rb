class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  attr_accessible :description, :financial_goal, :name, :owner, :pledges, :completion_date, :image, :youtube_url, :website_url
  
  belongs_to :owner, class_name: 'Member'
  has_many :pledges
  
  has_attached_file :image,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :storage => :s3,
    :bucket => 'cloud_funded',
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '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'
    }  
  
  validates_attachment_presence :image
  validates :website_url, presence: true
  validates :description, length: {maximum: 500}
  
  def youtube_url=(url)
    super(url.gsub(/watch\?v=/, 'embed/'))
  end
  
  def amount_pledged
    pledges.map(&:amount).sum
  end
  
  def percent_complete
    amount_pledged * 100 / financial_goal
  end
end
