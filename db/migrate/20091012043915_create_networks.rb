class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :interest_point_id, :null => false
      t.integer :map_layer_id, :null => false
      t.integer :map_icon_id, :null => false
      t.decimal :lat, :precision => 10, :scale => 6, :default => nil
      t.decimal :lng, :precision => 10, :scale => 6, :default => nil
      t.string :headline, :null => false
      t.string :body, :limit => 10000, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
