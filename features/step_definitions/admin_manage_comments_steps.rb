Given /^there is a comment with title "([^\"]*)" and body "([^\"]*)"$/ do |title, body|
  Factory.create(:comment, {:title  => title,
                            :body   => body
  })
end
