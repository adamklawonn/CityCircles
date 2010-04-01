class UserMailer < ActionMailer::Base
  
  def registration(user)
    recipients  user.email
    from        "members@citycircles.com"
    subject     "Thank you for Registering"
    body        :user => user
  end
  
  def welcome(user)
    recipients  user.email
    from        "members@citycircles.com"
    subject     "Thank you for Registering"
    body        :user => user
  end
  
end
