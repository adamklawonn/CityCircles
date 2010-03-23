Given /^I have a post with the following attributes:$/ do |table|
  pt = Factory.create(:post_type)
  map = Map.find_by_shortname( "lightrail")
  table.hashes.each do |attributes|
    Post.create!(attributes.merge({:post_type_id => pt.id, :ma}))
  end
end

Given /^I have a map with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    Map.create!(attributes)
  end
end