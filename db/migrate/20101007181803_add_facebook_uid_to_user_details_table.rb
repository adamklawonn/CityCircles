class AddFacebookUidToUserDetailsTable < ActiveRecord::Migration
  def self.up
       add_column :user_details, :facebook_uid, :integer, :limit => 8
     end

     def self.down
       remove_column :user_details, :facebook_uid
     end
end
