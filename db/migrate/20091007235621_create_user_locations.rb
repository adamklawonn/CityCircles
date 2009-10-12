class CreateUserLocations < ActiveRecord::Migration
  def self.up
    create_table :user_locations, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id, :null => false
      t.integer :interest_point_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_locations
  end
end
