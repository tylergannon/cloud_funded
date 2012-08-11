class OpenGraph::Action < ActiveRecord::Base
  attr_accessible :action_id, :member_id, :type, :graph_object, :graph_object_id, :graph_object_type, :member
  belongs_to :member
  belongs_to :graph_object, polymorphic: true
  
  validates :member_id, presence: true
  validates :type, presence: true
  validates :graph_object_id, presence: true
  validates :graph_object_type, presence: true
  validates :action_id, presence: true
end
