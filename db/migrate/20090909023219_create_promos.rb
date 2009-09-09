class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
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
