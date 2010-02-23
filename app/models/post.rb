# == Schema Information
# Schema version: 20100207115214
#
# Table name: posts
#
#  id                :integer(4)      not null, primary key
#  post_type_id      :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  map_layer_id      :integer(4)      not null
#  sticky            :boolean(1)
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  short_headline    :string(40)      not null
#  body              :text            default(""), not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Post < ActiveRecord::Base
  # breaking the rules with this include
  include ActionView::Helpers::TextHelper
  belongs_to :post_type
  belongs_to :interest_point
  belongs_to :map_layer
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_one :event
  has_one :tweet
  has_many :comments, :as => :commentable
  
  # YM4R
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  # Search
  define_index do
    # fields
    indexes headline, :sortable => true
    indexes body
    indexes author.login, :as => :author, :sortable => true

    # attributes
    has author_id, created_at, updated_at
  end
  
  # Validation
  validates_presence_of :headline, :short_headline, :body
  validates_presence_of :lat, :message => "you must choose a location."
  validates_acceptance_of :certification
  validates_associated :event, :if => Proc.new { | post | post.post_type == PostType.find_by_shortname( "events" ) }
  
  # Post attachments
  has_many :post_attachments
  
  # Label for map.
  def label
    short_headline
  end
  
  def name
    short_headline
  end
  
  # Info window. This is so bad.
  def info_window
    body_html = truncate( body, :length => 100 )
    if event != nil
      body_html = body_html + '<br /><br /><table width="100%"><tr><td align="right">Starts:</td><td align="center">' + self.event.starts_at.strftime( "%m/%d/%Y at %I:%M %p" ) + '</td></tr><tr><td align="right">Ends:</td><td align="center">' + self.event.ends_at.strftime( "%m/%d/%Y at %I:%M %p" ) + '</td></tr></table>'
    end
    body_html = body_html + '<br /><br /><a href="/posts/' + self.id.to_s + '">Read More...</a>'
    "<div class='map_info_window'><img src='#{ post_type.map_icon.image_url }' class='map_info_window_icon' /><h2 class='map_info_window_title'>#{ short_headline }</h2><br />#{ body_html }</div>"
  end
  
end
