# == Schema Information
# Schema version: 20100524015823
#
# Table name: promos
#
#  id              :integer(4)      not null, primary key
#  organization_id :integer(4)      not null
#  post_id         :integer(4)      not null
#  title           :string(255)     not null
#  author_id       :integer(4)      not null
#  starts_at       :datetime
#  ends_at         :datetime
#  is_approved     :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class Promo < ActiveRecord::Base
  belongs_to :organization
  belongs_to :post
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  # Validation
  validates_presence_of :title
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  validates_presence_of :post_id, :message => "must be present"
  validates_associated :post
end
