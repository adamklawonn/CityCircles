class CreatePostAttachments < ActiveRecord::Migration
  def self.up
    create_table :post_attachments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :post_id, :null => false
      t.string :caption, :null => false
      t.string :oembed, :default => nil
      t.text :code, :default => nil
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :post_attachments
  end
end
