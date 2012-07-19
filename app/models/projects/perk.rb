class Projects::Perk < ActiveRecord::Base
  attr_accessible :delivery_terms, :description, :name, :price, :quantity, :image
  belongs_to :project
  
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
