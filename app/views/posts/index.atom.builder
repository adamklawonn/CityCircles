atom_feed do |feed|

  if @poi != nil
    feed.title "City Circles #{ @post_type.name } posts for #{ @poi.label }"
  else
    feed.title "City Circles #{ @post_type.name } posts"
  end
  feed.updated @posts.first.created_at if @posts.any?
 
  @posts.each do |post|
    feed.entry( post ) do | entry |
      entry.title post.headline
      entry.content post.body, :type => 'html'
      entry.author do | author |
        author.name post.author.login
      end
    end
  end
end