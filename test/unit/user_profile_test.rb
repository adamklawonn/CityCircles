# == Schema Information
#
# Table name: user_profiles
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

require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
