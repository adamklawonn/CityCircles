class CreateBlogrollCategories < ActiveRecord::Migration
  def self.up
    create_table :blogroll_categories do |t|
      t.string :name, :null => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
    
    add_column :blogroll_feeds, :blogroll_category_id, :integer, :null => false
    
  end

  def self.down
    drop_table :blogroll_categories
    remove_column :blogroll_feeds, :blogroll_category_id
  end
end
