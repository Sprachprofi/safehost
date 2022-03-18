class Host < ApplicationRecord
  belongs_to :user
  
  scope :available, -> { where(available: true) }
  scope :taken, -> { where(available: false) }
  scope :women, -> { where("which_guests LIKE '%women%'") }
  scope :men, -> { where("which_guests LIKE '%xmen%'") }
  scope :couple, -> { where("which_guests LIKE '%couple%'") }
  scope :babies, -> { where("which_guests LIKE '%babies%'") }
  scope :dogs, -> { where("which_guests LIKE '%dogs%'") }
  scope :cats, -> { where("which_guests LIKE '%cats%'") }
  
  validates_presence_of :max_duration, :city
  validates :terms_of_service, acceptance: true
  
  accepts_nested_attributes_for :user
  self.implicit_order_column = "created_at"
  
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
  
  def self.import_from_csv(filename)
    headers = true
    # first run through: only create users
    CSV.foreach(filename, headers: headers, col_sep: ",") do |row|
      if !User.where(email: row['email'].downcase).exists?
        personal_name, family_name = row['name'].to_s.split(" ", 2)
        personal_name = "Unknown" if personal_name.blank?
        family_name = "Unknown" if family_name.blank?
        user = User.new(personal_name: personal_name, family_name: family_name, email: row['email'].downcase, mobile: row['mobile'], country: 'DE', city: row['city'], languages: row['languages'])
        user.social_links << ("https://t.me/" + row['social_links_telegram'].delete_prefix("@")) if !row['social_links_telegram'].blank?
        user.social_links << ("viber://chat?number=#{user.mobile.delete_prefix("+")}") if !row['social_links_viber'].blank?
        user.mobile = "+49" if user.mobile.blank?
        user.created_at = row['created_at']
        user.assign_random_password!
        user.terms_of_service = true
        user.is_host = true
        user.skip_confirmation_notification!
        user.save
        # byebug if not user.save
      end
    end

    # second run through: create hosts
    Host.bulk_insert(:user_id, :city, :country, :optimal_no_guests, :max_sleeps, :max_duration, :sleep_conditions, :which_guests, :which_hosts, :description, 
                               :languages, :created_at, :updated_at, :available, :guest_name, :guest_data, :pickup_data) do |worker|
      CSV.foreach(filename, headers: headers, col_sep: ",") do |row|
        user = User.find_by_email(row['email'].downcase)
        (raise "Could not find user " + row['email'].downcase) if user.nil?
        which_guests = "women xmen couple"
        which_guests += " babies" if row['description'] and (row['description'].include?(" bab") or row['description'].include?(" Baby"))
        which_guests += " infants youths" if row['description'] and (row['description'].include?(" child") or row['description'].include?(" Kind") or row['description'].include?(" Tochter"))
        (which_guests += " " + row['which_guests']) unless row['which_guests'].blank?
        sleep_cond = "common_room" if row['sleep_cond_common_room'] == '1'
        sleep_cond = "private_room" if row['sleep_cond_private_room'] == '1'
        worker.add [user.id, row['city'], 'DE', row['optimal_no_guests'], row['max_sleeps'], row['max_duration'], sleep_cond, which_guests, row['which_hosts'], 
                            row['description'], row['languages'], row['created_at'], Time.now, row['available'], row['guest_name'], row['guest_data'], row['pickup_data']]
      end
    end
    
  end
end
