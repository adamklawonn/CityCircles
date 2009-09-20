# == Schema Information
# Schema version: 20090913223316
#
# Table name: interest_points
#
#  id          :integer(4)      not null, primary key
#  label       :string(255)     not null
#  description :string(255)
#  lat         :float
#  lng         :float
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class InterestPoint < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :photos, :as => :photoable
  has_many :comments, :as => :commentable
end
