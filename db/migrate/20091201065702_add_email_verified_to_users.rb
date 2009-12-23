class AddEmailVerifiedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_verified, :boolean, :default => false
  end

  def self.down
    remove_column :users, :email_verified
  end
end
