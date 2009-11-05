class AddLatLngToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :lat, :decimal, :precision => 10, :scale => 6, :default => nil
    add_column :organizations, :lng, :decimal, :precision => 10, :scale => 6, :default => nil
  end

  def self.down
    remove_column :organizations, :lat
    remove_column :organizations, :lng
  end
end
