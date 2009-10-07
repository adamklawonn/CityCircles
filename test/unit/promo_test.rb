# == Schema Information
#
# Table name: promos
#
#  id                :integer(4)      not null, primary key
#  organization_id   :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  map_icon_id       :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  title             :string(255)     not null
#  description       :string(255)     not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
