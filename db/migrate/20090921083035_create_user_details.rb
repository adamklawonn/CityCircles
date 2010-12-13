class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :default => nil
      t.string :last_name, :default => nil
      t.string :twitter_username, :default => nil
      t.text :about_me, :default => nil
      t.string :employer, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :user_details
  end
end
