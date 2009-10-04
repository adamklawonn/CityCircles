# == Schema Information
# Schema version: 20091004012535
#
# Table name: pages
#
#  id                 :integer(4)      not null, primary key
#  parent_id          :string(255)
#  title              :string(255)     not null
#  shortname          :string(255)     not null
#  show_in_navigation :boolean(1)
#  description        :string(255)
#  body               :text
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Page < ActiveRecord::Base
  acts_as_tree :order => "page_order asc"
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
end
