class CreateFileAttachments < ActiveRecord::Migration
  def self.up
    create_table :file_attachments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :file_attachment_file_name, :null => false
      t.string :file_attachment_content_type, :null => false
      t.integer :file_attachment_file_size, :null => false
      t.references :file_attachable, :polymorphic => true
      t.integer :author_id, :null => false
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :file_attachments
  end
end
