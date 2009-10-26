class CreateUserInterests < ActiveRecord::Migration
  def self.up
    create_table :user_interests, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id, :null => false
      t.integer :interest_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_interests
  end
end
