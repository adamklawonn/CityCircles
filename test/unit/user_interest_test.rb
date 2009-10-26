# == Schema Information
#
# Table name: user_interests
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  interest_id :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class UserInterestTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
