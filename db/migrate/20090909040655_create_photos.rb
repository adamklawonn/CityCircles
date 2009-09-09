class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :title, :null => false
      t.string :caption, :default => nil
      t.string :photo_file_name, :null => false
      t.string :photo_content_type, :null => false
      t.integer :photo_file_size, :null => false
      t.references :photoable, :polymorphic => true
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end