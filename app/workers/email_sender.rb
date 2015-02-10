class EmailSender
  @queue = :high
  def self.perform(user_id)
    user = User.find(user_id)
    puts "Sending welcome email to #{user.email}"
    UserMailer.welcome_email(user).deliver
  end
end