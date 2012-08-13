class Members::Updates::Update < ActiveRecord::Base
  attr_accessible :member_id, :member, :object1_id, :object1_type, :object2_id, :object2_type, :read, :object1, :object2

  belongs_to :object1, polymorphic: true
  belongs_to :object2, polymorphic: true

  belongs_to :member
  
  validates :member, presence: true
  
  default_value_for(:read, false)
  
  def read?
    !!read
  end
end
