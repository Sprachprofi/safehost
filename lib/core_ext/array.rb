# encoding: UTF-8

class Array
  # difference between two arrays
  def ^(other)
    result = dup
    other.each { |e| result.include?(e) ? result.delete(e) : result.push(e) }
    result
  end unless method_defined?(:^)
  alias diff ^ unless method_defined?(:diff)
  
  # ensures that in an array of strings and subarrays, all strings become subarrays of [str, str] and the subarrays are in opposite direction
  # this fixes inconsistencies when calling a regular select box or a best-in-place select box on the array
  def fix_for_bip
    self.map { |e| e.is_a?(Array) ? e.reverse : [e, e] }
  end

  # get only ids of complex objects in array, e.g. for manipulated ActiveRecord results
  def ids
    self.map(&:id)
  end

  def include_any?(arr)
    not (self & arr).empty?
  end
  
  # return only elements that exist in both arrays
  def intersection(arr)
    self & arr
  end

  # each line from a file will be one entry in the array
  def self.from_file(filename)
    arr = []
    File.open(filename, 'r:utf-8') do |f|
      arr = f.read.split(/[\r\n]+/u)
    end
    arr
  end
end
