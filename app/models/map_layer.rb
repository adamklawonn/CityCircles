# == Schema Information
# Schema version: 20100410232227
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
  has_many :posts, :conditions => [ "is_draft = ?", false ]
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
  
  def recent_posts( layer_id, layer_shortname )
    Post.find( :all, :conditions => [ 'post_type_id = ? and map_layer_id = ? and ( posts.created_at >= ? and posts.created_at <= ? )', PostType.find_by_shortname( layer_shortname ), layer_id, 14.days.ago, 14.days.from_now ] )
  end
  
  def name
    title
  end
  
end
