class UserMailer < ActionMailer::Base
  
  def registration(user)
    recipients  "britton.halle@gmail.com"
    from        "britton.halle@gmail.com"
    subject     "Thank you for Registering"
    body        :user => user
  end
  
  def welcome(user)
    recipients  "britton.halle@gmail.com"
    from        "britton.halle@gmail.com"
    subject     "Thank you for Registering"
    body        :user => user
  end
  
end
