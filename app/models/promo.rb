# == Schema Information
# Schema version: 20091012043941
#
# Table name: promos
#
#  id                :integer(4)      not null, primary key
#  organization_id   :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  map_icon_id       :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  title             :string(255)     not null
#  description       :string(255)     not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Promo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :interest_point
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commenter
  has_many :photos, :as => :photoable
end
