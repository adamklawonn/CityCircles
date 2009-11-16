# == Schema Information
#
# Table name: organizations
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  name              :string(255)     not null
#  description       :string(255)
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
