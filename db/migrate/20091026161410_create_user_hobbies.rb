class CreateUserHobbies < ActiveRecord::Migration
  def self.up
    create_table :user_hobbies do |t|
      t.integer :user_id, :null => false
      t.integer :hobby_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_hobbies
  end
end
