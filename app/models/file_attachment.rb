# == Schema Information
# Schema version: 20091012043941
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
end
