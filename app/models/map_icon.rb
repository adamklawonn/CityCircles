# == Schema Information
# Schema version: 20091104061546
#
# Table name: map_icons
#
#  id                 :integer(4)      not null, primary key
#  shortname          :string(255)     not null
#  image_url          :string(255)     not null
#  icon_size          :string(255)     not null
#  shadow_url         :string(255)
#  shadow_size        :string(255)
#  icon_anchor        :string(255)     default("0, 0")
#  info_window_anchor :string(255)     default("0, 0")
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class MapIcon < ActiveRecord::Base
end
