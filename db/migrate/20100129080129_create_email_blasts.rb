class CreateEmailBlasts < ActiveRecord::Migration
  def self.up
    create_table :email_blasts do |t|
      t.datetime :send_at, :null => true
      t.boolean :is_active, :default => false
      t.boolean :was_sent, :default => false
      t.string :template, :null => false
      t.string :subject, :null => false
      t.text :body, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :email_blasts
  end
end
