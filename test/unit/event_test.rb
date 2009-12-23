# == Schema Information
#
# Table name: events
#
#  id         :integer(4)      not null, primary key
#  post_id    :integer(4)      not null
#  starts_at  :datetime        not null
#  ends_at    :datetime        not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
