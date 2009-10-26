# == Schema Information
# Schema version: 20091012063947
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
  has_many :news
  has_many :events
  has_many :networks
  has_many :stuffs
  has_many :fix_its
  has_many :interest_lines
  
  def points
    
    mapable_points = []
    
    self.interest_points.each do | poi |
      mapable_points << poi.to_point
    end
    
    self.news.each do | poi |
      mapable_points << poi.to_point
    end
    
    mapable_points
    
  end
  
end
