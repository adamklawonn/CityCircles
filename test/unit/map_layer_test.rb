# == Schema Information
#
# Table name: map_layers
#
#  id          :integer(4)      not null, primary key
#  map_id      :integer(4)      not null
#  title       :string(255)     not null
#  shortname   :string(255)     not null
#  description :string(255)
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class MapLayerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
