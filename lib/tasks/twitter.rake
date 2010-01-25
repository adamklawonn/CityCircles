require 'rubygems'

namespace :twitter do
  
  desc "Populate database from twitter."
  task :populate => [ :environment ] do
    
    # Get location twitter hashtags
    twitter_tags = InterestPoint.find( :all, :select => "twitter_hashtag", :conditions => [ "twitter_hashtag is not null" ] )
    twitter_tags = twitter_tags.collect { | tag | tag.twitter_hashtag }
    twitter_tags = twitter_tags.join( "|" )
    
    # Get post type twitter hashtags
    post_tags = PostType.find( :all, :select => "twitter_hashtag" )
    post_tags = post_tags.collect { | tag | tag.twitter_hashtag }
    post_tags = post_tags.join( "|" )
    
    client = Grackle::Client.new( :api => :v1 )
    
    query = client.search? :q => "@citycirc", :rpp => 100
    
    query.results.each do | result |
      tweet_id = result.id
      existing_tweet = Tweet.find_by_tweet_id( tweet_id )

      if existing_tweet == nil
        from_user = result.from_user
        text = result.text
        break_down = text.scan /(@citycirc)\s+(#{ post_tags })\s+{1}(#{ twitter_tags })\s+{1}(.*)/
        post_type = PostType.find_by_twitter_hashtag( break_down[ 0 ][ 1 ] )
        poi = InterestPoint.find_by_twitter_hashtag( break_down[ 0 ][ 2 ] )
        body = break_down[ 0 ][ 3 ]
        map_layer = post_type.map_layer
        user_profile = UserDetail.find_by_twitter_username( from_user )
        if user_profile != nil
          author = user_profile.user
        end

        post = Post.new( :headline => body[ 0..40 ], :short_headline => body[ 0..40 ], :body => body )
        post.author = ( author == nil ? User.find_by_login( "citycircles" ) : author )
        post.interest_point = poi
        post.map_layer = map_layer
        post.post_type = post_type
        post.lat = poi.lat + 0.004166666666667
        post.lng = poi.lng
        post.tweet = Tweet.new( :tweet_id => result.id, :body => text, :from_user => result.from_user, :to_user => result.to_user, :iso_language_code => result.iso_language_code, :source => result.source, :profile_image_url => result.profile_image_url, :tweeted_at => result.created_at )
        post.save!
      end
       
    end    
    
  end
  
end
