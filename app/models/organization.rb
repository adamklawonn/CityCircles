# == Schema Information
# Schema version: 20091104061546
#
# Table name: organizations
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  name              :string(255)     not null
#  description       :string(255)
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#

class Organization < ActiveRecord::Base
  belongs_to :interest_point
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :promos
end
