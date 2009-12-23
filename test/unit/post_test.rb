# == Schema Information
#
# Table name: posts
#
#  id                :integer(4)      not null, primary key
#  post_type_id      :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  map_layer_id      :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  short_headline    :string(40)      not null
#  body              :text            default(""), not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
