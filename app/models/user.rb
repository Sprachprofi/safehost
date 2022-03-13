class User < ApplicationRecord
  has_many :hosts, :dependent => :delete_all
  
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
 
  # verified_phone, verified_passport, verified_in_person, verified_address are all INTEGER
  # 0 = non-verified
  # 1 = uploaded/requested
  # 2 = verified 
  
  def assign_random_password!
    self.password = Devise.friendly_token.first(12)
    self.password_confirmation = self.password
  end
  
  def country_name(multilingual = true)
    if self.country
      country_data = ISO3166::Country[self.country]
      if country_data and multilingual
        country_data.translations[I18n.locale.to_s] || country_data.name
      elsif country_data
        country_data.name
      else
        self.country
      end
    else
      ''
    end
  end
  
  def country_phone_code
    if self.country and (country_data = ISO3166::Country[self.country])
      country_data.country_code
    else
      nil
    end
  end
  
  def fix_format
    self.personal_name.strip! if self.personal_name
    self.family_name.strip! if self.family_name
    self.mobile = mobile.standardise_phone_number if mobile
    self.email = email.downcase if email
  end
  
  # given a phone number, will fix the phone number with the country code
  # when using the strong parameter, even a guess will be used
  def guess_country_code(phone_no, strong = false)
    if !phone_no.blank? and !phone_no.starts_with?('+') and self.country and (country_data = ISO3166::Country[self.country]) and country_data.country_code
      if phone_no.starts_with?(country_data.country_code)
        # user definitely just forgot to add the + character
        phone_no = '+' + phone_no
      elsif strong
        # we suspect that the phone number was entered without country code
        phone_no = phone_no[1..-1] if phone_no.starts_with?('0') # remove 0 to dial out of region
        phone_no = '+' + country_data.country_code + phone_no
      end
    end
    phone_no
  end

  def in_Europe?
    %w(AL AD AT BE BG CH CY CZ DE DK EE ES FI FR GB GR HU HR IE IS IT LT LU LV MC MT NO NL PL PT RO RU SE SI SK).include?(self.country)
  end
  
  def verified_phone?
    !self.verified_phone.nil? and self.verified_phone > 1
  end
  
# FOR MOBILE VERIFICATION

  # generate a new pin unless one already exists
  def generate_phone_pin
    if self.confirmation_token.blank? or self.confirmation_token.length > 4
      self.confirmation_token = rand(0000..9999).to_s.rjust(4, '0')
      self.verified_phone = 1
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
      if self.confirmation_token == entered_pin
        self.verified_phone = 2
        self.confirmation_token = nil
        save
        return true
      end
    end
    false
  end

  
end
