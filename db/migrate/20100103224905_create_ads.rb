class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :organization_id, :null => false
      t.string :placement, :null => false
      t.datetime :starts_at, :default => nil
      t.datetime :ends_at, :default => nil
      t.integer :weight, :default => 1
      t.string :graphic_file_name
      t.string :graphic_content_type
      t.integer :graphic_file_size
      t.datetime :graphic_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
