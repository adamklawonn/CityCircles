class CreateOrganizationMembers < ActiveRecord::Migration
  def self.up
    create_table :organization_members do |t|
      t.integer :user_id, :null => false
      t.integer :organization_id, :null => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :organization_members
  end
end
