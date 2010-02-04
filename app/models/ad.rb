# == Schema Information
# Schema version: 20100104062711
#
# Table name: ads
#
#  id                   :integer(4)      not null, primary key
#  organization_id      :integer(4)      not null
#  placement            :string(255)     not null
#  starts_at            :datetime
#  ends_at              :datetime
#  weight               :integer(4)      default(1)
#  graphic_file_name    :string(255)
#  graphic_content_type :string(255)
#  graphic_file_size    :integer(4)
#  graphic_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Ad < ActiveRecord::Base

  # Relationships
  belongs_to :organization

  # Paperclip
  has_attached_file :graphic, :styles => { :small => "50x50#", :medium => "100x100>", :large => "220x240>", :huge => "300x300>" }, :path => ":rails_root/public/assets/ads/graphics/:id/:style_:basename.:extension", :url => "/assets/ads/graphics/:id/:style_:basename.:extension", :default_url => "/images/ad.jpg"

  #validates_inclusion_of :placement, :in => self.placement

  def self.placement
    %w( Profile Map Homepage-Header ).sort
  end

end