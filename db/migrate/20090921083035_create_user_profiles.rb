class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id, :null => false
      t.string :first_name, :default => nil
      t.string :last_name, :default => nil
      t.string :about_me, :length => 5000, :default => nil
      t.string :hobbies, :length => 500, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
