# == Schema Information
# Schema version: 20100104062711
#
# Table name: events
#
#  id         :integer(4)      not null, primary key
#  post_id    :integer(4)      not null
#  starts_at  :datetime        not null
#  ends_at    :datetime        not null
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
  belongs_to :post  
end
