class AddDraftToPosts < ActiveRecord::Migration
  def self.up
  
    add_column :posts, :is_draft, :boolean, :default => false
  
  end

  def self.down

    remove_column :posts, :is_draft

  end
end
