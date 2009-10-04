# == Schema Information
# Schema version: 20091004012535
#
# Table name: user_wireless_profiles
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)      not null
#  wireless_carrier_id :string(255)
#  wireless_number     :string(255)
#  subscriptions       :string(255)
#  digest              :boolean(1)      default(TRUE)
#  created_at          :datetime
#  updated_at          :datetime
#

class UserWirelessProfile < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :wireless_carrier
  
end
