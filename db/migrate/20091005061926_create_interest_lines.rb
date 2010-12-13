class CreateInterestLines < ActiveRecord::Migration
  def self.up
    create_table :interest_lines do |t|
      t.integer :map_id, :null => false
      t.integer :map_layer_id, :null => false
      t.string :label, :null => false
      t.string :shortname, :null => false
      t.string :description, :default => nil
      t.decimal :lat, :precision => 10, :scale => 6, :default => nil
      t.decimal :lng, :precision => 10, :scale => 6, :default => nil
      t.integer :author_id, :null => false
      t.timestamps
    end
    
    add_index :interest_lines, :map_id
    add_index :interest_lines, :map_layer_id
    add_index :interest_lines, :shortname
    
  end

  def self.down
    drop_table :interest_lines
  end
end
