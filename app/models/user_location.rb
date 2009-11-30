# == Schema Information
# Schema version: 20091128210317
#
# Table name: user_locations
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :interest_point
end
