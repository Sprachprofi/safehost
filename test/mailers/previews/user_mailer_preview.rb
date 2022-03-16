class UserMailerPreview < ActionMailer::Preview
  
  def admin_message
    UserMailer.admin_message(User.first.email, "Random message", "<p>This will be an <b>HTML</b> email!</p>")
  end

  def random_message
    UserMailer.random_message(User.first, "Random message", "<p>This will be an <b>HTML</b> email!</p>")
  end
  
  def welcome
    UserMailer.welcome(User.last, :de)
  end

end
