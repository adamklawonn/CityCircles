# == Schema Information
# Schema version: 20090913223316
#
# Table name: maps
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :string(255)     not null
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Map < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commenter
end
