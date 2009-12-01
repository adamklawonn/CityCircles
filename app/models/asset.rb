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
  has_attached_file :data,
                    :styles => { :tiny => "64x64#",
                                 :small => "176x112#",
                                 :medium => "630x630>",
                                 :large => "1024x1024>" }
  def url(*args)
    data.url(*args)
  end
  
  def name
    data_file_name
  end
  
  def content_type
    data_content_type
  end
  
  def browser_safe?
    %w(jpg gif png).include?(url.split('.').last.sub(/\?.+/, "").downcase)
  end
  alias_method :web_safe?, :browser_safe?
  
  # This method will replace one of the existing thumbnails with an file provided.
  def replace_style(style, file)
    style = style.downcase.to_sym
    if data.styles.keys.include?(style)
      if File.exist?(RAILS_ROOT + '/public' + a.data(style))
      end
    end
  end
  
  # This method assumes you have images that corespond to the filetypes.
  # For example "image/png" becomes "image-png.png"
  def icon
    "#{data_content_type.gsub(/[\/\.]/,'-')}.png"
  end
    
  def detach(attached)
    a = attachings.find(:first, :conditions => ["attachable_id = ? AND attachable_type = ?", attached, attached.class.to_s])
    raise ActiveRecord::RecordNotFound unless a
    a.destroy
  end
end
