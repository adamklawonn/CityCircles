# == Schema Information
#
# Table name: pages
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)     not null
#  shortname          :string(255)     not null
#  show_in_navigation :boolean(1)
#  description        :string(255)
#  body               :text
#  sort               :integer(4)      default(1)
#  author_id          :integer(4)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
