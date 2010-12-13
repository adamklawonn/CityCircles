class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :post_type_id, :null => false
      t.integer :interest_point_id, :null => false
      t.integer :map_layer_id, :null => false
      t.boolean :sticky, :default => false
      t.decimal :lat, :precision => 10, :scale => 6, :default => nil
      t.decimal :lng, :precision => 10, :scale => 6, :default => nil
      t.string :headline, :null => false
      t.string :short_headline, :limit => 40, :null => false
      t.text :body, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
