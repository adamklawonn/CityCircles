class CreateMapIcons < ActiveRecord::Migration
  def self.up
    create_table :map_icons, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :shortname, :null => false
      t.string :image_url, :null => false
      t.string :icon_size, :null => false
      t.string :shadow_url, :default => nil
      t.string :shadow_size, :default => nil
      t.string :icon_anchor, :default => "0, 0"
      t.string :info_window_anchor, :default => "0, 0"
      t.integer :author_id, :null => false
      t.timestamps
    end
    
    add_index :map_icons, :shortname
    
  end

  def self.down
    remove_index :map_icons, :shortname
    drop_table :map_icons
  end
end
