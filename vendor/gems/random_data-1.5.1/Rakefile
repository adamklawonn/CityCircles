begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "random_data"
    gemspec.summary = gemspec.description = "Provides a Random class with a series of methods for generating random test data including names, mailing addresses, dates, phone numbers, e-mail addresses, and text."
    gemspec.email = "mike@subelsky.com"
    gemspec.homepage = "http://github.com/otherinbox/random_data"
    gemspec.authors = ["Mike Subelsky"]
    gemspec.add_development_dependency "mocha"
    gemspec.test_files = %w(test/test_random_data.rb)
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end