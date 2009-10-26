# == Schema Information
#
# Table name: photos
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)     not null
#  caption            :string(255)
#  image_file_name    :string(255)     not null
#  image_content_type :string(255)     not null
#  image_file_size    :integer(4)      not null
#  photoable_id       :integer(4)
#  photoable_type     :string(255)
#  lat                :decimal(10, 6)
#  lng                :decimal(10, 6)
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
