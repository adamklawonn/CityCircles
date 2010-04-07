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
    when /^the edit page for interest "([^\"]*)"/
      "/admin/interests/edit/#{Interest.find_by_name($1).id}"
    when /^my profile page/
      '/user'
    when /^the admin dashboard/
      admin_dashboard_path
    when /^the admin new promo page/
      '/admin'+new_promo_path
    when /^the admin edit promo page for "([^\"]*)"/
      #TODO: this path doesn't work, seems to be something to do with typus?
      #'/admin'+edit_promo_path(Promo.find_by_title($1))
      "/admin/promos/edit/#{Promo.find_by_title($1).id}"
    when /^the admin wireless carriers list page/
      '/admin'+wireless_carriers_path
    when /^the wireless carrier edit page for "([^\"]*)"/
      "/admin/wireless_carriers/edit/#{WirelessCarrier.find_by_name($1).id}"
    when /^the admin hobbies list page/
      '/admin'+hobbies_path
    when /^the admin hobbies new page/
      '/admin'+new_hobby_path
    when /^the admin hobby edit page for "([^\"]*)"/
      "/admin/hobbies/edit/#{Hobby.find_by_name($1).id}"
    when /^the admin interest point list page/
      #can't find a route for this
      '/admin/interest_points'
    when /^the admin organizations list page/
      #can't find a route for this
      '/admin/organizations'
    when /^the admin interest point new page/
      #can't find a route for this
      '/admin/interest_points/new'
    when /^the admin interest point edit page for "([^\"]*)"/
      "/admin/interest_points/edit/#{InterestPoint.find_by_label($1).id}"
    when /^the admin organization edit page for "([^\"]*)"/
      "/admin/organizations/edit/#{Organization.find_by_name($1).id}"
    when /^the admin "([^\"]*)" "([^\"]*)" page/
      "/admin/#{$1}/#{$2}"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
