# == Schema Information
# Schema version: 20100207115214
#
# Table name: user_details
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)      not null
#  first_name          :string(255)
#  last_name           :string(255)
#  twitter_username    :string(255)
#  about_me            :text
#  employer            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#

class UserDetail < ActiveRecord::Base

  belongs_to :user

	# Paperclip
  has_attached_file :avatar, :styles => { :small => "50x50#", :medium => "100x100>", :large => "220x240>", :huge => "300x300>" }, :path => ":rails_root/public/system/assets/user_details/avatars/:id/:style_:basename.:extension", :url => "/system/assets/user_details/avatars/:id/:style_:basename.:extension", :default_url => "/images/avatar.jpg"


end
