# == Schema Information
# Schema version: 20091012063947
#
# Table name: photos
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)     not null
#  caption            :string(255)
#  photo_file_name    :string(255)     not null
#  photo_content_type :string(255)     not null
#  photo_file_size    :integer(4)      not null
#  photoable_id       :integer(4)
#  photoable_type     :string(255)
#  lat                :decimal(10, 6)
#  lng                :decimal(10, 6)
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Photo < ActiveRecord::Base
  
  belongs_to :photoable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commentable
  has_attached_file :photo, :styles => { :small => "50x50>", :medium => "100x100>", :large => "150x150>" }
  
  def photoable_type=( sType )
    super( sType.to_s.classify.constantize.base_class.to_s )
  end
  
end
