# encoding: UTF-8

class String

  def crude_comparable_string
    # remove Greek letters and remove accented characters and downcase
    self.to_ascii_transliteration.downcase
  end

  # comparison of differences
  # assumes that the str_a[5] == str_b[5] and so on, so not very intelligent
  def difference_percent(b)
    a = self
    longer = [a.size, b.size].max
    same = a.each_char.zip(b.each_char).select { |a, b| a == b }.size
    (longer - same) / a.size.to_f
  end

  # finds the best match for the current string within the given array
  def find_closest_match_pos(arr)
    arr.map { |el| self.difference_percent(el) }.each_with_index.min[1]
  end

  def find_item_based_on_longest_common_substring(arr)
    str = self.greek_comparable_string
    m = arr.map { |el|  str.longest_common_substring(el.greek_comparable_string).length }
    # check if any match 70% length of original string or matched string
    substring_length, pos = m.each_with_index.max
    matched_item = arr[pos]
    if (substring_length / str.length.to_f > 0.7) or (substring_length / matched_item.length.to_f > 0.7)
      matched_item
    else
      nil
    end
  end

  # downcases and removes accent marks in order to make two Greek strings easier to compare
  def greek_comparable_string()
    capitals = "ΑΒΓΔΕΖΗΙΚΛΜΝΟΠΡΣΤΥΦΧΩΞΘΨΆΈΉΊΌΎΏάέήίόύώςϊ"
    down = "αβγδεζηικλμνοπρστυφχωξθψαεηιουωαεηιουωσι"
    self.tr(capitals, down)
  end
  
  def greek_remove_accents
    accented = "άέήίόύώΆΈΉΊΌΎΏΪ"
    unaccented = "αεηιουωΑΕΗΙΟΥΩΙ"
    self.tr(accented, unaccented)
  end

  def greek_upcase
    capitals = "ΑΒΓΔΕΖΗΙΚΛΜΝΟΠΡΣΤΥΦΧΩΞΘΨΣ"
    down = "αβγδεζηικλμνοπρστυφχωξθψς"
    self.tr(down, capitals)
  end
  
  def gsub_if(condition, searchstr, replacestr)
    if condition
      self.gsub(searchstr, replacestr)
    else
      self
    end
  end
  
  # very crude guesser
  def guess_language
    s = self.downcase
    if s.include?("η") or s.include?("ε")
      "Ελληνικά"
    elsif s.include?(" you ") or self.include?(" I ") or s.include?(" my ") or s.include?(" at ")
      "English"
    elsif s.include?("ã") or s.include?("õ")
      "Português"
    elsif s.include?("ů") or s.include?("ř")
      "Čeština"
    elsif s.include?("š") or s.include?("č")
      "BiH/CRO/SRB"
    elsif s.include?("ğ") or s.include?("ı") or s.include?("ş")
      "Türkçe"
    elsif s.include?("ä") or s.include?("ß") or s.include?(" und ")
      "Deutsch"
    elsif s.include?("ç") or s.include?(" et ") or s.include?(" à ")
      "Français"
    elsif s.include?("ñ") or s.include?(" y ") or s.include?(" el ") or s.include?(" los ") or s.include?(" las ") or s.include?("ión")
      "Español"
    elsif s.include?(" è ") or s.include?(" di ") or s.include?(" e ") or s.include?(" non ")
      "Italiano"
    elsif s.include?("é ")  # if it wasn't Spanish, should be French
      "Français"
    else
      nil  # probably still English
    end
  end

  def longest_common_substring(b)
    a = self
    lengths = Array.new(a.length) { Array.new(b.length, 0) }
    greatestLength = 0
    output = ''
    a.each_char.with_index do |x, i|
      b.each_char.with_index do |y, j|
        next if x != y

        lengths[i][j] = (i.zero? || j.zero?) ? 1 : lengths[i - 1][j - 1] + 1
        if lengths[i][j] > greatestLength
          greatestLength = lengths[i][j]
          output = a[i - greatestLength + 1, greatestLength]
        end
      end
    end
    output
  end
  
  def looks_link?
    self.include?("http") or self.include?("www") 
  end
  
  # checks whether an address includes an @ character and a dot somewhere to the right of it
  def looks_valid_email?
    pos = self.rindex("@")
    pos2 = self.rindex(".")
    if pos2 
      domain = self[(pos2+1)..-1]
      valid_domain = !((domain.include?("x") and domain != "mx") or (domain.include?("v") and domain != "lv") or (domain.include?("f") and domain != "fr"))
    else
      valid_domain = false
    end
    return !!(pos and pos2 and (pos2 > (pos+2)) and valid_domain)
  end

  # no parenthesis, spaces or other funny characters
  # format like +4915153721439
  def standardise_phone_number
    s = self.gsub('(0)', '') # remove national prefix not used internationally
    s = s.gsub(/[^0-9\+]*/, '')
    s = '+' + s[2..-1] if s[0, 2] == '00'
    s
  end
  
  # only the user name, no URL or @
  def standardise_twitter
    if self.include?("twitter.com")
      self.split('/').last
    else
      self.strip.delete_prefix("@")
    end
  end
  
  def strip_tags
    ActionController::Base.helpers.strip_tags(self)
  end
  
  def to_ascii_transliteration
    s = self.to_unaccented_greeklish
        accented = "áàâāäąéèêěēëęėíìîīïıóòôōöúùûūüŭųßćĉçčđǵĝğĥĵłńṕŕśšŝşźžżÁÀÂĀÄĄÉÈÊĒËĘĖÍÌÎĪÏİÓÒÔŌÖÚÙÛŪÜŬŲĆĈÇČĐǴĜĞĤĴŁŃṔŔŚŠŜŞŹŽŻ"
    unaccented = "aaaaaaeeeeeeeeiiiiiiooooouuuuuuusccccdggghjlnprsssszzzAAAAAAEEEEEEEIIIIIIOOOOOUUUUUUUCCCCDGGGHJLNPRSSSSZZZ"
    s.tr(accented, unaccented)
  end

  def to_greeklish
    greek = "αβγδεζηικλμνοπρστυφωξάέήίόύώςΑΒΓΔΕΖΗΙΚΛΜΝΟΠΡΣΤΥΦΩΞΆΈΉΊΌΎΏ"
    greeklish = "avgdeziiklmnoprstyfox\xC3\xA1\xC3\xA9\xC3\xAD\xC3\xAD\xC3\xB3y\xC3\xB3sAVGDEZIIKLMNOPRSTYFOX\xC3\x81\xC3\x89\xC3\x8D\xC3\x8D\xC3\x93Y\xC3\x93"
    s = self.tr(greek, greeklish)
    if s != self  # this is Greek
      s = s.gsub("\xCE\xB8", 'th').gsub("\xCF\x87", 'ch').gsub("\xCF\x88", 'ps').gsub("\xCE\x98", 'Th').gsub('X', 'Ch').gsub("\xCE\xA8", 'Ps').gsub('oy', 'ou').gsub('Oy', 'Ou').gsub('ay', 'av').gsub('ey', 'ev').gsub('Ay', 'Av').gsub('Ey', 'Ev').gsub('gg', 'ng').gsub('Nt', 'D').gsub('Mp', 'B')
    end
    s
  end

  def to_unaccented_greeklish
    greek = "\xCE\xB1\xCE\xB2\xCE\xB3\xCE\xB4\xCE\xB5\xCE\xB6\xCE\xB7\xCE\xB9\xCE\xBA\xCE\xBB\xCE\xBC\xCE\xBD\xCE\xBF\xCF\x80\xCF\x81\xCF\x83\xCF\x84\xCF\x85\xCF\x86\xCF\x89\xCE\xBE\xCE\xAC\xCE\xAD\xCE\xAE\xCE\xAF\xCF\x8C\xCF\x8D\xCF\x8E\xCF\x82\xCE\x91\xCE\x92\xCE\x93\xCE\x94\xCE\x95\xCE\x96\xCE\x97\xCE\x99\xCE\x9A\xCE\x9B\xCE\x9C\xCE\x9D\xCE\x9F\xCE\xA0\xCE\xA1\xCE\xA3\xCE\xA4\xCE\xA5\xCE\xA6\xCE\xA9\xCE\x9E\xCE\x86\xCE\x88\xCE\x89\xCE\x8A\xCE\x8C\xCE\x8E\xCE\x8F"
    greeklish = 'avgdeziiklmnoprstyfoxaeiioyosAVGDEZIIKLMNOPRSTYFOXAEIIOYO'
    s = self.tr(greek, greeklish)
    if s != self  # this is Greek
      s = s.gsub("\xCE\xB8", 'th').gsub("\xCF\x87", 'ch').gsub("\xCF\x88", 'ps').gsub("\xCE\x98", 'Th').gsub('X', 'Ch').gsub("\xCE\xA8", 'Ps').gsub('oy', 'ou').gsub('Oy', 'Ou').gsub('ay', 'av').gsub('ey', 'ev').gsub('Ay', 'Av').gsub('Ey', 'Ev').gsub('gg', 'ng').gsub('Nt', 'D')
    end
    s
  end
  
  def to_russian_romanisation
    russian_single = "АБВГДЕЁЗИЙКЛМНОПРСТУФЫЭабвгдеёзийклмнопрстуфыэ"
    latin_single = "ABVGDEEZIIKLMNOPRSTUFYEabvgdeeziiklmnoprstufye"
    russian_double = %w(Ж ж Х х Ц Ч Ш Щ Ъ ц ч ш щ ъ Ю Я ю я)
    latin_double = %w(Zh zh Kh kh Ts Ch Sh Shch Ie ts ch sh shch ie Iu Ia iu ia)
    s = self.tr(russian_single, latin_single)
    russian_double.each_with_index do |letter, i|
      s.gsub!(letter, latin_double[i])
    end
    s.gsub!(/[Ьь]/, '')  # this letter does not get transferred to romanization
    s
  end

  def with_https
    if self.starts_with?('http')
      self
    elsif self.starts_with?('//')
      'https:' + self
    end
  end
  
  def without_postal_code
    parts = self.split(" ")
    parts.delete_if{ |part| part.match(/\d/) }.join(" ")
  end

  # find if this string includes any of the strings from the array (case insensitive)
  def find_one_word_from(arr)
    test_str = ' ' + self + ' '
    arr.each do |str|
      return str if test_str.include?(' ' + str.downcase + ' ')
    end
    nil
  end

  # check if string includes any members of the array
  def include_any?(arr)
    arr.any? { |str| self.include?(str) }
  end

  def is_Numeric?
    self.to_i.to_s == self
  end

  def remove_css_styles!(*styles)
    s = self
    styles.each do |style|
      s.gsub!(/#{style}[^;]+; ?/, '')
    end
    s.gsub!(' style=""', '')
    s
  end
end
