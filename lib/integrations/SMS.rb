class SMS
  def self.client
    Twilio::REST::Client.new(Rails.application.credentials.twilio_account_sid, Rails.application.credentials.twilio_auth_token)
  end

  def self.send(number, message)
    status = 'waiting'
    if valid_number?(number)
      begin
        self.client.messages.create(
          to: number,
          from: Rails.application.credentials.twilio_phone_number,
          body: message
        )
        status = 'success'
      rescue Twilio::REST::RestError
        status = 'error'
      end
    else
      status = 'bad number'
    end
    status
  end

  def self.send_all_users(users, message)
    success_count = 0
    users.each_with_index do |u, i|
      response = begin
        SMS.send(u.mobile, message)
      rescue
        nil
      end
      success_count += 1 if response == 'success'
      # update status if it's a huge set of users
      puts "Processed #{i} of #{users.size} users to message" if ((i % 100) == 0)
    end
    success_count
  end

  # utility function

  def self.valid_number?(number)
    !number.nil? and number.starts_with?('+') and (number.length > 9) and (not number.include?(' '))
  end
end
