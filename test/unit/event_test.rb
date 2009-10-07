# == Schema Information
#
# Table name: events
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  map_icon_id       :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  body              :string(255)     not null
#  starts_at         :datetime        not null
#  ends_at           :datetime        not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
