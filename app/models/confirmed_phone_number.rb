class ConfirmedPhoneNumber < ApplicationRecord
  validates_uniqueness_of :phone_no

  # note: pin_sendings is actually pin_sending requests. Any request beyond the third request for the same
  # number won't be handled, due to a potential spamming / running up bills problem

  def self.mobile_number_available?(number)
    not ConfirmedPhoneNumber.where(:phone_no => number).exists?
  end
end
