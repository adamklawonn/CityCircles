class CreateInterestPointIcons < ActiveRecord::Migration
  def self.up
    create_table :interest_point_icons, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :image_url, :null => false
      t.string :shadow_url, :default => nil
      t.string :icon_anchor, :default => 0
      t.string :info_window_anchor, :default => 0
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :interest_point_icons
  end
end
