# == Schema Information
# Schema version: 20100207115214
#
# Table name: maps
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :string(255)     not null
#  shortname   :string(255)     not null
#  lat         :decimal(10, 6)  not null
#  lng         :decimal(10, 6)  not null
#  zoom        :integer(4)      default(0)
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Map < ActiveRecord::Base
    
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :map_layers
  has_many :interest_points
  has_many :interest_lines
  has_many :comments, :as => :commenter
  
end
