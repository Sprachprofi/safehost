# encoding: UTF-8

class Time
  def display_datetime_for_country(country)
    datetime = self
    case country
    when "GR", "CY"
      if I18n.locale == :el
        (datetime + 1.hour).strftime('%-d/%-m, %H:%M') + " Ώρα Ελλάδος"
      else
        (datetime + 1.hour).strftime('%-d/%-m, %H:%M') + " Greek time"
      end
    when "BG", "LT", "LV", "RO", "FI"
      (datetime + 1.hour).strftime('%B %-d, %H:%M') + " EET"
    when "GB", "IE", "IS"
      (datetime - 1.hour).strftime('%B %-d, %H:%M') + " GMT"
    when "TR"
      (datetime + 2.hours).strftime('%B %-d, %H:%M') + " TRT"
    when "US", "CA"
      if datetime.hour > 8  # only do timezone conversion if it doesn't change the date of the event
        (datetime - 6.hours).strftime('%B %-d, %H:%M') + " EST"
      else
        datetime.strftime('%B %-d, %H:%M') + " CET"
      end
    else
      if (I18n.locale == :de) or (country == 'DE')
        datetime.strftime('%B %-d, %H:%M') + " MEZ"
      elsif (I18n.locale == :fr) or (country == 'FR')
        datetime.strftime('%B %-d, %H:%M') + " HNEC"
      elsif (I18n.locale == :it) or (country == 'IT')
        datetime.strftime('%B %-d, %H:%M') + " TEC"
      else
        datetime.strftime('%B %-d, %H:%M') + " CET"
      end
    end
  end
  
  # localise doesn't work because it gives the month names in the nominative
  def display_datetime_with_month_for_greece
    # build string
    str = self.day.to_s + " " 
    months = %w(Ιανουαρίου Φεβρουαρίου Μαρτίου Απριλίου Μαΐου Ιουνίου Ιουλίου Αυγούστου Σεπτεμβρίου Οκτωβρίου Νοεμβρίου Δεκεμβρίου)
    str += months[self.month - 1] + " "
    str += self.strftime("%Y %H:%M")
    str
  end

end
