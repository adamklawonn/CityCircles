# == Schema Information
# Schema version: 20100524015823
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
  validates_presence_of :starts_at, :message => "must have a start date and time."
  validates_presence_of :ends_at, :message => "must have an end date and time."
end
