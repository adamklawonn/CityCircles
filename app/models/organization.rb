# == Schema Information
# Schema version: 20091003085734
#
# Table name: organizations
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  name              :string(255)     not null
#  description       :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Organization < ActiveRecord::Base
  belongs_to :interest_point
  has_many :promos
end
