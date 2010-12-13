class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.string :title, :null => false
      t.string :description, :length => 5000, :null => false
      t.string :shortname, :null => false
      t.decimal :lat, :precision => 10, :scale => 6, :null => false
      t.decimal :lng, :precision => 10, :scale => 6, :null => false
      t.integer :zoom, :default => 0
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
