class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :null => false
      t.string :body, :length => 1000, :null => false
      t.integer :author_id, :null => false
      t.references :commenter, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
