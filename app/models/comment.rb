# == Schema Information
# Schema version: 20091012043941
#
# Table name: comments
#
#  id             :integer(4)      not null, primary key
#  title          :string(255)     not null
#  body           :string(255)     not null
#  author_id      :integer(4)      not null
#  commenter_id   :integer(4)
#  commenter_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commenter, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  
  def commenter_type=( sType )
    super( sType.to_s.classify.constantize.base_class.to_s )
  end
  
end
