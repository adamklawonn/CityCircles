# == Schema Information
# Schema version: 20100410232227
#
# Table name: hobbies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Hobby < ActiveRecord::Base  
  has_many :email_blast, :as => :blastable
end
