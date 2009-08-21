namespace :dev do
  
  desc "Populate database with test data."
  task :populate_db => :environment do
    
    user = User.new( :login => 'caiges', :email => 'caigesn@gmail.com', :password => 'devel', :password_confirmation => 'devel' )
    user.save!
    
  end
  
end