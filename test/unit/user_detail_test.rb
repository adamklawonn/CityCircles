# == Schema Information
#
# Table name: user_details
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)      not null
#  first_name          :string(255)
#  last_name           :string(255)
#  about_me            :string(255)
#  hobbies             :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#

require 'test_helper'

class UserDetailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
