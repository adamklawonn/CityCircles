# == Schema Information
# Schema version: 20091012043941
#
# Table name: user_details
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  first_name :string(255)
#  last_name  :string(255)
#  about_me   :string(255)
#  hobbies    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UserDetail < ActiveRecord::Base

  belongs_to :user

end
