class CreateHobbies < ActiveRecord::Migration
  def self.up
    create_table :hobbies, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :hobbies
  end
end
