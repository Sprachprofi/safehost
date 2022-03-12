# encoding: UTF-8

class CSV
  
  def self.detect_separator(file)
    firstline = File.open(file, &:readline)
    if firstline
      separators = ",;\t|#"
      non_sep = "[^" + separators + "]+"
      sep = "([" + separators + "])"
      reg = Regexp.new(non_sep + sep + non_sep + sep + non_sep + sep + non_sep + sep)
      m = firstline.match(reg)
      if m 
        four_separators = m[1..-1].join('') # this line should have four separators but may have less if the data is less conclusive
        detected_separator = separators.split('').map {|x| [four_separators.count(x),x]}.max
        return detected_separator[1] if detected_separator
      end
    end
    nil
  end
  
end
