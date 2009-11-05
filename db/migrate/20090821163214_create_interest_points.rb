class CreateInterestPoints < ActiveRecord::Migration
  def self.up
    create_table :interest_points, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :map_id, :null => false
      t.integer :map_layer_id, :null => false
      t.integer :map_icon_id, :null => false
      t.string :label, :null => false
      t.string :body, :default => nil
      t.string :description, :default => nil
      t.decimal :lat, :precision => 10, :scale => 6, :default => nil
      t.decimal :lng, :precision => 10, :scale => 6, :default => nil
      t.integer :author_id, :null => false
      t.timestamps
    end
    
    add_index :interest_points, :map_id
    add_index :interest_points, :map_layer_id
    add_index :interest_points, :map_icon_id
    
  end

  def self.down
    remove_index :interest_points, :map_id
    drop_table :interest_points
  end
end
