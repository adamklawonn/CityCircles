# == Schema Information
# Schema version: 20091003085734
#
# Table name: news
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  headline          :string(255)     not null
#  body              :string(255)     not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class News < ActiveRecord::Base
  belongs_to :interest_point
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_many :comments, :as => :commenter
  has_many :photos, :as => :photoable
end
