# == Schema Information
# Schema version: 20100524015823
#
# Table name: wireless_carriers
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  email_gateway :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class WirelessCarrier < ActiveRecord::Base
  
  has_many :user_wireless_profiles
  
end
