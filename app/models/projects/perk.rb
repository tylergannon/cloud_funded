class Projects::Perk < ActiveRecord::Base
  attr_accessible :delivery_terms, :description, :name, :price, :quantity, :image
  attr_accessible :price_in_cents
  belongs_to :project
  has_many :pledges
  
  monetize :price_cents
  
  def price_in_cents=(p)
    self.price = p.to_f / 100
  end
  
  def price_in_cents
    (price * 100).to_i
  end
  
  S3_DEETS = {
    :styles => { large: "200x200", :thumb => "100x100" },
    :storage => :s3,
    :s3_protocol => '',
    :bucket => ENV['AMAZON_S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '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'
    }  
  }
  
  has_attached_file :image, S3_DEETS
  
  def as_json
    {
      "perk_#{id}_image" => {
        url_original: image.url(:original),
        url_large: image.url(:large),
        url_medium: image.url(:medium),
        url_small: image.url(:small)
      }
    }
  end
end
