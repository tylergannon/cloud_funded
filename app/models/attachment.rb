class Attachment < ActiveRecord::Base
  attr_accessible :title, :image
  belongs_to :attachable, polymorphic: true

  has_attached_file :image,
    :styles => { :medium => "300x200", :thumb => "100x100" },
    :storage => :s3,
    :bucket => ENV['AMAZON_S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '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'
    }  

end
