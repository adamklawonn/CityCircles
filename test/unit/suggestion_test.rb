# == Schema Information
#
# Table name: suggestions
#
#  id         :integer(4)      not null, primary key
#  email      :string(100)     not null
#  body       :string(5000)    not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
