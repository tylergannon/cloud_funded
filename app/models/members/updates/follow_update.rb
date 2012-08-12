class Members::Updates::FollowUpdate < Members::Updates::Update
  attr_accessible :project, :follower
  validates :project, presence: true
  validates :follower, presence: true
  
  alias_attribute :project, :object1
  alias_attribute :follower, :object2
end