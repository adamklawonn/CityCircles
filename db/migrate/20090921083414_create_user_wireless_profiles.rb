class CreateUserWirelessProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_wireless_profiles do |t|
      t.integer :user_id, :null => false
      t.string :wireless_carrier_id, :nil => false
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
