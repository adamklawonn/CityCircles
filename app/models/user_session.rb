class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Your username/password combination was invalid!"
#  facebook_skip_new_user_creation true
end