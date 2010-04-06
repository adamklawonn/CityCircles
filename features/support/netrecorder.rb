# NOTE: If we want to start stubbing out calls to things like geokit and other outside webservices do the following
# uncomment the following code then run
# rake features RECORD_WEB=true

# NetRecorder.config do |config|
#   config.cache_file = "#{File.dirname(__FILE__)}/../support/fakeweb"
#   if ENV['RECORD_WEB']
#     config.record_net_calls = true
#   else
#     config.fakeweb = true
#     FakeWeb.allow_net_connect = false
#   end
# end
# 
# at_exit do
#   if NetRecorder.recording?
#     NetRecorder.cache!
#   end
# end