class CreateSiteOptions < ActiveRecord::Migration
  def self.up
    create_table :site_options, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :length => 255, :nil => false
      t.string :option_value, :length => 255, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :site_options
  end
end
