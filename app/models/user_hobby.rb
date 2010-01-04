# == Schema Information
# Schema version: 20100104062711
#
# Table name: user_hobbies
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  hobby_id   :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class UserHobby < ActiveRecord::Base

  belongs_to :hobby
  belongs_to :user
  
  validates_uniqueness_of :hobby_id, :scope => :user_id, :message => "The same hobby cannot be added more than once."
  
end
