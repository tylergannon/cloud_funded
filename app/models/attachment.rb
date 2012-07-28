class Attachment < ActiveRecord::Base
  attr_accessible :title, :image
  belongs_to :attachable, polymorphic: true

  has_attached_file :image,
    {:styles => { :medium => "300x200", :thumb => "100x100" }}.merge(AppConfig.paperclip_storage)
    
  validates :image, attachment_presence: true

end
