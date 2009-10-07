# == Schema Information
#
# Table name: interest_points
#
#  id           :integer(4)      not null, primary key
#  map_id       :integer(4)      not null
#  map_layer_id :integer(4)      not null
#  map_icon_id  :integer(4)      not null
#  label        :string(255)     not null
#  body         :string(255)
#  description  :string(255)
#  lat          :decimal(10, 6)
#  lng          :decimal(10, 6)
#  author_id    :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class InterestPointTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
