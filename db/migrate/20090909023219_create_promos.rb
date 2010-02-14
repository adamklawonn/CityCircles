class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :organization_id, :null => false
      t.integer :post_id, :null => false
      t.string :title, :null => false
      t.integer :author_id, :null => false
      t.datetime :starts_at, :default => nil
      t.datetime :ends_at, :default => nil
      t.boolean :is_approved, :default => false
      t.timestamps
    end
    
  end

  def self.down
    drop_table :promos
  end
end
