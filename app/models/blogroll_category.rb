# == Schema Information
# Schema version: 20100524015823
#
# Table name: blogroll_categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  is_active  :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class BlogrollCategory < ActiveRecord::Base
  has_many :blogroll_categories
end
