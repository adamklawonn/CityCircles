class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :headline, :null => false
      t.string :body, :length => 5000, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
