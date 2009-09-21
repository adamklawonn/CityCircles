class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Your username/password combination was invalid!"
end