# == Schema Information
# Schema version: 20100104062711
#
# Table name: pages
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)     not null
#  shortname          :string(255)     not null
#  show_in_navigation :boolean(1)
#  description        :string(255)
#  body               :text
#  sort               :integer(4)      default(1)
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Page < ActiveRecord::Base

  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  validates_uniqueness_of :shortname

end
