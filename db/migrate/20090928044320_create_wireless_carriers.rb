class CreateWirelessCarriers < ActiveRecord::Migration
  def self.up
    create_table :wireless_carriers do |t|
      t.string :name, :nil => false
      t.string :email_gateway, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :wireless_carriers
  end
end
