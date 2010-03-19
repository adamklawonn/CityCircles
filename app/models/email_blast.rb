# == Schema Information
# Schema version: 20100319044343
#
# Table name: email_blasts
#
#  id             :integer(4)      not null, primary key
#  send_at        :datetime
#  is_active      :boolean(1)
#  was_sent       :boolean(1)
#  template       :string(255)     not null
#  subject        :string(255)     not null
#  body           :text            default(""), not null
#  author_id      :integer(4)      not null
#  created_at     :datetime
#  updated_at     :datetime
#  blastable_id   :integer(4)
#  blastable_type :string(255)
#

class EmailBlast < ActiveRecord::Base
  belongs_to :blastable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :email_blast_template, :class_name => "EmailBlastTemplate", :foreign_key => "template"
end
