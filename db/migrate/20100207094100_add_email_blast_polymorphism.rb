class AddEmailBlastPolymorphism < ActiveRecord::Migration
  def self.up
    add_column :email_blasts, :blastable_id, :integer
    add_column :email_blasts, :blastable_type, :string
  end

  def self.down
    remove_column :email_blasts, :blastable_id, :integer
    remove_column :email_blasts, :blastable_type, :string
  end
end
