# == Schema Information
# Schema version: 20100104062711
#
# Table name: interests
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Interest < ActiveRecord::Base    
  has_many :email_blast, :as => :blastable
end
