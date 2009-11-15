# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  attachings_count  :integer(4)      default(0)
#  created_at        :datetime
#  data_updated_at   :datetime
#

require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
