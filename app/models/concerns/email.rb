module Email
  extend ActiveSupport::Concern
  
  included do
    before_validation :fix_email_format
  end
  
  def email_with_name
    self.name.strip + ' <' + self.email + '>'
  end
  
  def fix_email_format
    self.email = email.downcase.strip if email
  end
  
  def md5_email
    Digest::MD5.hexdigest(self.email.downcase)
  end
  
  def md5_token
    Digest::MD5.hexdigest(self.email + self.created_at.to_s)
  end
  
  def potential_duplicate_emails
    email = self.email
    self.class.where("email LIKE '%#{email[2, 8]}%' OR REPLACE(email, '.', '') = '#{email.gsub('.', '')}'").where("id != #{self.id}")
  end
  
end
