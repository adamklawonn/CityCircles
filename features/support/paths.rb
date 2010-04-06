module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    when /^the contact us page/
      contact_page_path
    when /^the login page/
      signin_path
    when /^the signup page/
      signup_path
    when /^the new organization page/
      "/admin/organizations/new"
    when /^the advanced search page/
      search_path
    when /the new post page with a point of interest and post type \"Events\"/
      new_post_path(:poi_id => InterestPoint.first.id, :pt => "Events")
    when /the new post page with a point of interest and post type \"News\"/
      new_post_path(:poi_id => InterestPoint.first.id, :pt => "News")
    when /^the new event page$/
      new_event_path
    when /^the organizations page/
      organizations_path
    when /^the "([^\"]*)" profile page/
      user_path(User.find_by_login($1))
    when /^my settings page/
      settings_path
    when /^the settings page/
      settings_path
    when /^my profile page/
      '/user'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
