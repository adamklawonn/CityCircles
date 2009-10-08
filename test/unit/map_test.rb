# == Schema Information
#
# Table name: maps
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :string(255)     not null
#  shortname   :string(255)     not null
#  lat         :decimal(10, 6)  not null
#  lng         :decimal(10, 6)  not null
#  zoom        :integer(4)      default(0)
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class MapTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
