# == Schema Information
# Schema version: 20091012043941
#
# Table name: news
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  map_layer_id      :integer(4)      not null
#  map_icon_id       :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  body              :text            default(""), not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class News < ActiveRecord::Base
  belongs_to :interest_point
  belongs_to :map_layer
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :map_icon
  has_many :comments, :as => :commenter
  #has_many :photos, :as => :photoable
  #has_many :attachments, :as => :file_attachable
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  def label 
    headline
  end
  
  def info_window
    "<strong>#{ headline }</strong><br /><br /><a href='/news/#{ id }'>Read this story >></a>"
  end
  
end
