class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :organization_id, :null => false
      t.integer :interest_point_id, :null => false
      t.string :title, :null => false
      t.string :description, :length => 5000, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
