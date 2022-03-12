class User < ApplicationRecord
  has_one :host
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
         
  include RealName
  include Email
  include Hierarchy
         
  before_validation :nilify_blanks, :fix_format
         
  validates_presence_of :personal_name, :family_name, :email, :mobile
  validates :email, uniqueness: { case_sensitive: false }
  validates :postal_code, length: { maximum: 20 }, allow_blank: true
  validates :city, length: { maximum: 50 }, allow_blank: true
  validates :terms_of_service, acceptance: true
  
  serialize :social_links, Array
  
  def assign_random_password!
    self.password = Devise.friendly_token.first(12)
    self.password_confirmation = self.password
  end
  
  def fix_format
    self.personal_name.strip! if self.personal_name
    self.family_name.strip! if self.family_name
    self.mobile = mobile.standardise_phone_number if mobile
    self.email = email.downcase if email
  end
  
# FOR MOBILE VERIFICATION

  # generate a new pin unless one already exists
  def generate_phone_pin
    if self.confirmation_token.blank? or self.confirmation_token.length > 4
      self.confirmation_token = rand(0000..9999).to_s.rjust(4, '0')
      save
    end
  end

  def send_phone_pin
    sent = false
    p = ConfirmedPhoneNumber.where(:phone_no => self.mobile).first_or_initialize(:user_id => self.id, :pin_sendings => 0)
    p.pin_sendings += 1
    p.save
    if p.pin_sendings <= 3 and ConfirmedPhoneNumber.where(:user_id => self.id).count <= 4
      # max 3 tries with this number and max 4 different numbers
      SMS.send(mobile, I18n.t('verify.text_message', pin: confirmation_token))
      sent = true
    end
    sent
  end

  def verify_phone_pin(entered_pin)
    p = ConfirmedPhoneNumber.where(:phone_no => self.mobile).first
    p.pin_typing_attempts += 1
    p.save
    if p.pin_typing_attempts <= 20 # max 20 tries, after that even a correct pin won't be accepted (protect against brute-force)
      if self.verification_state == VERIFIED_EMAIL and self.confirmation_token == entered_pin
        self.verification_state = VERIFIED_PHONE
        self.confirmation_token = nil
        save
        return true
      end
    end
    false
  end

  
end
