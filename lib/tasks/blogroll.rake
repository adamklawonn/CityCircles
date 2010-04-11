namespace :aggregator do

  desc "Parse the feeds in the system and store them for sane access."
  task :parse => :environment do
    
    feeds = BlogrollFeed.all

    feeds.each do | feed |
      parsed_feed = FeedNormalizer::FeedNormalizer.parse open( feed.feed_uri.strip )
      feed.parsed_feed = parsed_feed
      feed.save! 
    end

  end

end
