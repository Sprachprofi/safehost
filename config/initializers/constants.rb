# encoding: utf-8

puts "Emailing is disabled because no Sparkpost password was found - check Rails Credentials. This need not be a problem unless you're testing emailing." if Rails.application.credentials[:sparkpost_password].nil?

LANGUAGE_NAME = {
  sr: "BiH/CRO/SRB",
  ca: "Catal\xC3\xA0",
  cs: "\xC4\x8Ce\xC5\xA1tina",
  da: 'Dansk',
  de: 'Deutsch',
  el: "Ελληνικά",
  en: 'English',
  es: "Español",
  fr: "Français",
  hu: "Magyar",
  it: 'Italiano',
  nl: 'Nederlands',
  no: 'Norsk',
  pl: 'Polski',
  pt: "Português",
  ro: "Română",
  sq: "Shqip",
  sl: "Sloven\xC5\xA1\xC4\x8Dina",
  sv: "Svenska",
  tr: "Türkçe"
}

CORE_LANGUAGE_NAME = {
  de: 'Deutsch',
  el: "Ελληνικά",
  en: 'English',
  es: "Español",
  fr: "Français",
  it: 'Italiano',
  pt: "Português",
}
 
ALL_LANGUAGE_NAMES = LANGUAGE_NAME.values
ALL_LANGUAGE_CODES = LANGUAGE_NAME.keys.map(&:to_s)

LANGUAGE_CODE = LANGUAGE_NAME.invert # works as a lookup method: LANGUAGE_CODE["Deutsch"] => "de"

SLEEP_CONDITIONS = ["common_room", "private_room", "private_bathroom", "use_kitchen", "work_desk","free_parking","washing_machine"]
HOST_TYPES = ["one_man", "one_woman", "couple", "xmen", "women", "babies", "infants", "youths", "elderly", "dogs", "cats", "other_pets"]
GUEST_TYPES = ["xmen", "women", "couple", "babies", "infants", "youths", "elderly", "disabled", "People of Color", "dogs", "cats", "other_pets"]

has_database = begin
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad
  false
else
  true
end

# Cities
CITY_DATA_FOR_COUNTRIES = %w(GR FR NL BE DE AT CH IT ES PT GB)
