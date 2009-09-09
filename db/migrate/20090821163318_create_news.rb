class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :headline, :null => false
      t.string :body, :length => 5000, :null => false
      t.integer :author_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
