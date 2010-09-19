# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Fix Rubygems 1.3.6 with Rails 2.3.5
# See https://rails.lighthouseapp.com/projects/8994/tickets/4026-rubygems-136-warning-in-rails-235
if Gem::VERSION >= "1.3.6"
    module Rails
        class GemDependency
            def requirement
                r = super
                (r == Gem::Requirement.default) ? nil : r
            end
        end
    end
end

Rails::Initializer.run do |config|
  
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  config.action_controller.session_store = :active_record_store
  
  ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcZfQgAAAAAAGOII0ryh_w5BOjq7GK4Td7Y2Y3R'
  ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcZfQgAAAAAACIo0Q5yt79bY7o6XNFtpMzz4WLQ'
  
end

# Fix sloppy Rails error handling code in form helpers.
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
"<span class=\"fieldWithErrors\">#{html_tag}</span>" }
