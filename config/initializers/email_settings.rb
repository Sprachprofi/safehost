ActionMailer::Base.smtp_settings = {
  user_name: 'SMTP_Injection',
  password: Rails.application.credentials.sparkpost_password,
  address: 'smtp.eu.sparkpostmail.com',
  port: 587,
  enable_starttls_auto: true,
  # authentication: :login,
  format: :html,
  from: 'info@safehost.space'
}

# store list of disposable emails
#TEMP_DOMAINS = File.readlines(Rails.root.join('config/disposable_emails.txt')).map { |line| line.strip }
