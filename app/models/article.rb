class Article < ActiveRecord::Base
  attr_accessible :body, :published_at, :title
end
