# == Schema Information
# Schema version: 20091003085734
#
# Table name: map_layers
#
#  id          :integer(4)      not null, primary key
#  map_id      :integer(4)      not null
#  title       :string(255)     not null
#  shortname   :string(255)     not null
#  description :string(255)
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class MapLayer < ActiveRecord::Base
  belongs_to :map
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :interest_points
end
