class CreateEmailBlastTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_blast_templates do |t|
      t.string :name, :null => true
      t.string :template_filename, :null => true
      t.boolean :is_active, :default => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :email_blast_templates
  end
end
