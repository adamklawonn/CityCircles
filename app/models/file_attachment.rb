# == Schema Information
# Schema version: 20091201065827
#
# Table name: file_attachments
#
#  id                           :integer(4)      not null, primary key
#  file_attachment_file_name    :string(255)     not null
#  file_attachment_content_type :string(255)     not null
#  file_attachment_file_size    :integer(4)      not null
#  file_attachable_id           :integer(4)
#  file_attachable_type         :string(255)
#  author_id                    :integer(4)      not null
#  created_at                   :datetime
#  updated_at                   :datetime
#

class FileAttachment < ActiveRecord::Base

  belongs_to :file_attachable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commenter
  has_attached_file :file_attachment
  
  def photable_type=( sType )
    super( sType.to_s.classify.constantize.base_class.to_s )
  end
  
end
