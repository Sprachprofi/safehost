class Hash

  # turns a hash of hashes into a single flat hash with dots in keys (like in I18n: { "groups.errors.too_big" => "Your group is too big." })
  def flatten_with_dot_notation(prefix=nil)
    param = self
    param.each_pair.reduce({}) do |a, (k, v)|
      v.is_a?(Hash) ? a.merge(v.flatten_with_dot_notation("#{prefix}#{k}.")) : a.merge("#{prefix}#{k}".to_sym => v)
    end
  end
  
  
  # given a hash with number values, e.g. a hash produced by a grouped count query
  # this will sum up the given keys
  # e.g.  members_by_country = User.member.group(:country).count
  #         members_by_country.sum_values_of("US", "CA", "MX") => combined number of members in North America
  def sum_values_of(*keys)
    sum = 0
    keys.each do |key|
      sum += self[key] if self[key]
    end
    sum
  end

  # Rekey a hash:
  #
  #   rekey()
  #   rekey(from_key => to_key, ...)
  #   rekey{|from_key| to_key}
  #   rekey{|from_key, value| to_key}
  #
  # If a key map is given, then the first key is changed to the second key.
  #
  #   foo = { :a=>1, :b=>2 }
  #   foo.rekey(:a=>'a')       #=> { 'a'=>1, :b=>2 }
  #   foo.rekey(:b=>:x)        #=> { :a =>1, :x=>2 }
  #   foo.rekey('foo'=>'bar')  #=> { :a =>1, :b=>2 }
  #
  # If a block is given, converts all keys in the Hash accroding to the
  # given block procedure.
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.rekey{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo                      #=>  { :name =>"Gavin", :wife=>:Lisa }
  #
  # If no key map or block is given, then all keys are converted
  # to Symbols.
  #
  # Raises an ArgumentError if both a +key_map+ and a block are given.
  # If both are needed just call #rekey twice.
  #
  # TODO: If `nil` is returned by block should the key be set to `nil` or the orignal key?
  #
  # CREDIT: Trans, Gavin Kistner

  def rekey(key_map = nil, &block)
    raise ArgumentError, 'argument or block' if key_map && block

    if !(key_map or block)
      block = lambda { |k| k.to_sym }
    end

    if block
      hash = dup.clear
      if block.arity.abs == 1
        each_pair do |k, v|
          hash[block[k]] = v # hash[block[k] || k] = v
        end
      else
        each_pair do |k, v|
          hash[block[k, v]] = v # hash[block[k,v] || k] = v
        end
      end
    else
      # hash = dup.clear  # to keep default_proc
      # (keys - key_map.keys).each do |key|
      #  hash[key] = self[key]
      # end
      # key_map.each do |from, to|
      #  hash[to] = self[from] if key?(from)
      # end
      hash = dup # to keep default_proc
      key_map.each_pair do |from, to|
        hash[to] = hash.delete(from) if hash.key?(from)
      end
    end

    hash
  end

  # Synonym for Hash#rekey, but modifies the receiver in place (and returns it).
  #
  #   foo = { :name=>'Gavin', :wife=>:Lisa }
  #   foo.rekey!{ |k| k.to_s }  #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #   foo                       #=>  { "name"=>"Gavin", "wife"=>:Lisa }
  #
  # CREDIT: Trans, Gavin Kistner

  def rekey!(key_map = nil, &block)
    replace(rekey(key_map, &block))
  end
  
  # in a hash with name and numerical value, such as a statistics, 
  # sums up the values of everything below the threshold under an "Other" item
  # and rejects items of value zero (including the "Other" item)
  def summarise(threshold, misc_name = "Other")
    new_hash = {misc_name => 0}
    each_pair do |key, value|
      if value < threshold
        new_hash[misc_name] += value
      else
        new_hash[key] = value 
      end
    end
    new_hash.delete(misc_name) if new_hash[misc_name] == 0
    new_hash
  end
end
