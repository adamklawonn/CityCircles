# == Schema Information
#
# Table name: promos
#
#  id              :integer(4)      not null, primary key
#  organization_id :integer(4)      not null
#  post_id         :integer(4)      not null
#  title           :string(255)     not null
#  description     :string(255)     not null
#  author_id       :integer(4)      not null
#  starts_at       :datetime
#  ends_at         :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
