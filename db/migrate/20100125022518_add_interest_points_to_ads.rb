class AddInterestPointsToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :interest_point_id, :integer
  end

  def self.down
    remove_column :ads, :interest_point_id
  end
end
