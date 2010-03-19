class AddLinkagesToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :link_uri, :string, :default => nil
    add_column :ads, :popup_html, :text, :default => nil
  end

  def self.down
    remove_column :ads, :link_uri
    remove_column :ads, :popup_html
  end
end
