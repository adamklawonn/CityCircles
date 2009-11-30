# == Schema Information
# Schema version: 20091128210317
#
# Table name: hobbies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Hobby < ActiveRecord::Base  
end
