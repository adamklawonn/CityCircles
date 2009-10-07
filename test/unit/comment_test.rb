# == Schema Information
#
# Table name: comments
#
#  id             :integer(4)      not null, primary key
#  title          :string(255)     not null
#  body           :string(255)     not null
#  author_id      :integer(4)      not null
#  commenter_id   :integer(4)
#  commenter_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
