class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :about_me, :length => 5000, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
