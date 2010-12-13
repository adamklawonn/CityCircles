class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.integer :organization_id, :null => false
      t.string :placement, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false
      t.integer :weight, :default => 1
      t.string :graphic_file_name, :null => false
      t.string :graphic_content_type
      t.integer :graphic_file_size
      t.datetime :graphic_updated_at
      t.boolean :is_approved, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
