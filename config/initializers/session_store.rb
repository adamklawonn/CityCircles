# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_railsphx_session',
  :secret      => '6e2c242ae89d41af8deaf1f1d570ea87c21cf45f5fd5ad0455b28c5d1e084fe09ade11d76d7933717b85f591473bc6ebd52a71a899a30859a6ade3491be2213b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
