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
#  interest_point_id    :integer(4)      not null
#

class Ad < ActiveRecord::Base

  # Relationships
  belongs_to :organization

  # Paperclip
  has_attached_file :graphic, :styles => { :small => "50x50#", :medium => "100x100>", :large => "220x240>", :huge => "300x300>" }, :path => ":rails_root/public/assets/ads/graphics/:id/:style_:basename.:extension", :url => "/assets/ads/graphics/:id/:style_:basename.:extension", :default_url => "/images/ad.jpg"

  #validates_inclusion_of :placement, :in => self.placement
  validates_attachment_presence :graphic, :message => "must be an image."  
  validates_presence_of :placement
  validates_presence_of :organization_id
  validates_presence_of :starts_at, :message => "must have a start date and time."
  validates_presence_of :ends_at, :message => "must have an end date and time."
  
  def self.placement
    [ { :placement => 'Homepage Map', :size => 'height : 100px, width : 100px' }, { :placement => 'Homepage Under Map', :size => 'height : 100px, width : 940px' }, { :placement => 'Profile Map', :size => 'height : 100px, width : 100px' } ]
  end
  
end
