class CreateUserWirelessProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_wireless_profiles do |t|
      t.integer :user_profile_id, :null => false
      t.string :wireless_carrier, :default => nil
      t.string :wireless_number, :default => nil
      t.string :subscriptions, :default => nil
      t.boolean :digest, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :user_wireless_profiles
  end
end
