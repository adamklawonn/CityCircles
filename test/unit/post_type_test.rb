# == Schema Information
#
# Table name: post_types
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)     not null
#  map_icon_id     :integer(4)      not null
#  shortname       :string(255)     not null
#  twitter_hashtag :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class PostTypeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
