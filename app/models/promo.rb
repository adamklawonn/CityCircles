# == Schema Information
# Schema version: 20091128210317
#
# Table name: promos
#
#  id              :integer(4)      not null, primary key
#  organization_id :integer(4)      not null
#  post_id         :integer(4)      not null
#  title           :string(255)     not null
#  description     :string(255)     not null
#  author_id       :integer(4)      not null
#  starts_at       :datetime
#  ends_at         :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Promo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :interest_point
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commenter
  has_many :photos, :as => :photoable
end
