# == Schema Information
# Schema version: 20100410232227
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)     not null
#  body             :string(255)     not null
#  author_id        :integer(4)      not null
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  def commenter_type=( sType )
    super( sType.to_s.classify.constantize.base_class.to_s )
  end
  
end
