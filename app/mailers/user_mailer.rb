class UserMailer < ApplicationMailer
  default from: 'SafeHost <info@safehost.space>'
  layout 'mailer'
  helper ApplicationHelper

  rescue_from ArgumentError do |exception|
    # besides the exception variable, you have here the message method that has all message attributes, so you can save that message.to(it is always an array) are invalid emails
    body = exception.to_yaml
    UserMailer.admin_message('tech@diem25.org', 'UserMailer ArgumentError', body).deliver_now
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    body = exception.to_yaml
    UserMailer.admin_message('tech@diem25.org', 'UserMailer User not found' , message.to_s + "---" + body).deliver_now
  end

  def admin_message(to, subject, body)
    @body = body
    mail(:from => 'SafeHost <info@safehost.space>', :to => to, :subject => subject)
  end

  def export_data(user, data)
    @user = user
    @data = data
    mail(:from => 'SafeHost <info@safehost.space>', :to => @user.email, :subject => 'Your data')
  end

  def random_user_message(user, subject, body, from = "SafeHost <info@safehost.space>")
    @body = body.gsub("*|FNAME|*", user.personal_name)
    @user = user
    mail(:from => from, :to => @user.email_with_name, :subject => subject.gsub("*|FNAME|*", user.personal_name))
  end
  
  # used to email non-member email addresses, e.g. for SYMPA commands
  def random_outside_message(email, subject, body, from = "SafeHost <info@safehost.space>")
    @body = body
    mail(:from => from, :to => email, :subject => subject)
  end
  
  def welcome(user, locale = :en)
    @user = user
    I18n.locale = locale
    mail(to: user.email_with_name, subject: I18n.t("emails.welcome"))
  end

  private

  # turns "It's your choice" into "Judith, it's your choice"
  def try_add_name(str, user)
    if user and user.personal_name
      str = user.personal_name + ', ' + str[0, 1].downcase + str[1..-1]
    end
    str
  end
end
