# == Schema Information
# Schema version: 20100524015823
#
# Table name: email_blast_templates
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  template_filename :string(255)
#  is_active         :boolean(1)
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class EmailBlastTemplate < ActiveRecord::Base
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :email_blast
end
