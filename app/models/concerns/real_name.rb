module RealName
  extend ActiveSupport::Concern

  included do
    validates :personal_name, format: { with: /\A[^*\/!\@;#$%0123456789]+\z/,
                                      message: 'only allows letters' }
    validates :personal_name, format: { without: /(www|http)/i }
    validates :family_name, format: { with: /\A[^*\/!\@;#$%0123456789]+\z/,
                                    message: 'only allows letters' }
    validates :family_name, format: { without: /(www|http)/i }
    
    ransacker :std_name do
      Arel.sql("unaccent(concat(personal_name,' ',family_name))")
    end
  end
  
  def name
    if personal_name and family_name
      (personal_name + ' ' + family_name)
    elsif personal_name
      personal_name
    else
      'DiEMer'
    end
  end
  alias to_s name
  
  def potential_duplicate_names
    self.personal_name.strip!
    self.family_name.strip!
    self.class.where('family_name LIKE ? AND personal_name LIKE ?', "%#{self.family_name}%", "%#{self.personal_name}%").where("id != #{self.id}")
  end

  def username
    if personal_name and family_name
      (personal_name + ' ' + family_name[0, 1])
    else
      begin
        email.match(/(.+)@.+/)[1].gsub('.', ' ').titleize
      rescue
        email
      end
    end
  end
  
end
