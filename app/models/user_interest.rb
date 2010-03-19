# == Schema Information
# Schema version: 20100319044343
#
# Table name: user_interests
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  interest_id :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class UserInterest < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :interest
  
  validates_uniqueness_of :interest_id, :scope => :user_id, :message => "The same interest cannot be added more than once."
  
end
