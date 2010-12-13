class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :post_id, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false
      t.timestamps
    end
    
    add_index :events, :post_id
    
  end

  def self.down
    remove_index :events, :post_id
    drop_table :events
  end
end
