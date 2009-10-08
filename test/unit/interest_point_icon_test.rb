# == Schema Information
#
# Table name: interest_point_icons
#
#  id                 :integer(4)      not null, primary key
#  image_url          :string(255)     not null
#  shadow_url         :string(255)
#  icon_anchor        :string(255)     default("0")
#  info_window_anchor :string(255)     default("0")
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class InterestPointIconTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
