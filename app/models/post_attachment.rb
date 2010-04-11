# == Schema Information
# Schema version: 20100410232227
#
# Table name: post_attachments
#
#  id                      :integer(4)      not null, primary key
#  post_id                 :integer(4)      not null
#  caption                 :string(255)     not null
#  oembed                  :string(255)
#  code                    :text
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer(4)
#  attachment_updated_at   :datetime
#  created_at              :datetime
#  updated_at              :datetime
#

class PostAttachment < ActiveRecord::Base
  
  belongs_to :post
  
  # Paperclip
  has_attached_file :attachment, :styles => { :small => "50x50#", :medium => "100x100>", :large => "220x240>", :huge => "300x300>" }, :path => ":rails_root/public/system/assets/posts/attachments/:id/:style_:basename.:extension", :url => "/system/assets/posts/attachments/:id/:style_:basename.:extension", :default_url => "/images/attachment.jpg"
  
  # Check content type and don't run Paperclip::Thumbnail processor on non-image files
  before_post_process :image?
  
  def image?
    !(attachment_content_type =~ /^image.*/).nil?
  end
  
end
