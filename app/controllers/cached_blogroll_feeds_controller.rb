class CachedBlogrollFeedsController < ApplicationController
    # Instructions: 1. Change @@secret. 2. Add a cron job to regularly call /?recache=yes&secret=XXXXXXX
    # This is a feed aggregator that uses FeedTools because it handles practically any feed.
    # But FeedTools is super slow in every way so this aggregator stops using it as soon as possible.
    # TODO add XML feed output

    @@secret = "change_this" # change this to protect your site from DoS attack
    
    def index
      if params[:recache] and @@secret == params[:secret]
        cache_feeds
        expire_fragment(:controller => 'cachedblogrollfeeds', :action => 'index') # next load of index will re-fragment cache
        render :text => "Done recaching feeds"
      else
        @aggregate = read_cache unless read_fragment({})
      end
    end

  private
  
    # This will replace cached feeds in the DB that have the same URI. Be careful not to tie up the DB connection.
    def cache_feeds
      puts "Caching feeds... (can be slow)"
      feeds = BlogrollFeed.find( :all ).map do |f|
        feed = FeedTools::Feed.open( f.feed_uri )
        { :uri => f.feed_uri, :title => feed.title, 
          :items => feed.items.map { |item| {:title => item.title, :published => item.published, :link => item.link} } }
      end
      feeds.each do | feed |
        puts feed.class
        new_feed = CachedBlogrollFeed.find_or_initialize_by_uri( feed[ 'uri' ] )
        new_feed.parsed_feed = feed
        new_feed.save!
      end
    end
    
    # Make an array of hashes, each hash is { :title, :feed_item }
    def read_cache
      BlogrollFeed.find( :all ).map { |f|
        feed = CachedBlogrollFeed.find_by_uri( f.feed_uri ).parsed_feed
        feed[:items].map { |item| {:feed_title => feed[:title], :feed_item => item} }
      } .flatten .sort_by { |item| item[:feed_item][:published] } .reverse
    end
    
end
