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
end
