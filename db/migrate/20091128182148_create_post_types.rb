class CreatePostTypes < ActiveRecord::Migration
  def self.up
    create_table :post_types, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :null => false
      t.integer :map_layer_id, :null => false
      t.integer :map_icon_id, :null => false
      t.string :map_fill_color, :default => "#000000"
      t.string :map_stroke_color, :default => "#d3d3d3"
      t.integer :map_stroke_width, :default => 2
      t.string :shortname, :null => false
      t.string :twitter_hashtag, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :post_types
  end
end
