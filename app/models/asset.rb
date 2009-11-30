# == Schema Information
# Schema version: 20091128210317
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

class Asset < ActiveRecord::Base

	has_many :attachings, :dependent => :destroy
  has_attached_file :data, :styles => { :small => "50x50>", :medium => "100x100>", :large => "150x150>" }

end
