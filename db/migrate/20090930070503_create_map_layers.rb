class CreateMapLayers < ActiveRecord::Migration
  def self.up
    create_table :map_layers, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :map_id, :null => false
      t.string :title, :null => false
      t.string :shortname, :null => false
      t.string :description, :default => nil
      t.integer :author_id, :null => false
      t.timestamps
    end
    
    add_index :map_layers, :map_id
    
  end

  def self.down
    drop_table :map_layers
  end
end
