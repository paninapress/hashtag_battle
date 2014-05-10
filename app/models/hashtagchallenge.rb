class Hashtagchallenge < ActiveRecord::Base
  belongs_to :user
  serialize :hashtags, Array
  serialize :counts
end
