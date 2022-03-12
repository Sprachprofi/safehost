class Host < ApplicationRecord
  belongs_to :user
  
  validates_presence_of :max_duration, :city
  validates :terms_of_service, acceptance: true
  
  accepts_nested_attributes_for :user
end
