class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.integer :interest_point_id, :null => false
      t.string :name, :null => false
      t.string :description, :length => 5000, :default => nil
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
