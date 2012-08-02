class Projects::Perk < ActiveRecord::Base
  attr_accessible :delivery_terms, :description, :name, :price, :quantity, :image
  belongs_to :project
  has_many :pledges
  
  monetize :price_cents

  default_scope order(:id)

  S3_DEETS = {
    :styles => { large: "200x200", :thumb => "100x100" }
  }
  
  has_attached_file :image, S3_DEETS.merge(AppConfig.paperclip_storage)
  
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
