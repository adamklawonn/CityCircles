# == Schema Information
# Schema version: 20091007235621
#
# Table name: site_options
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  option_value :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class SiteOption < ActiveRecord::Base
end
