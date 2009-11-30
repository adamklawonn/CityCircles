class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :post_id, :null => false
      t.integer :tweet_id, :null => false
      t.string :body, :null => false
      t.string :from_user, :null => false
      t.string :to_user, :default => nil
      t.string :iso_language_code, :default => nil
      t.string :source, :default => nil
      t.string :profile_image_url, :default => nil
      t.string :tweeted_at, :null => false
      t.string :location, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
