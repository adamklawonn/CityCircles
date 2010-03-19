# == Schema Information
# Schema version: 20100319044343
#
# Table name: suggestions
#
#  id         :integer(4)      not null, primary key
#  email      :string(100)     not null
#  body       :string(5000)    not null
#  created_at :datetime
#  updated_at :datetime
#

class Suggestion < ActiveRecord::Base
end
