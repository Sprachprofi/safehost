class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # finds all records which correspond to the given ids or emails
  def self.find_by_array(emails_or_ids)
    if emails_or_ids.first.is_a?(String)
      field = 'email'
    elsif emails_or_ids.first.is_a?(Integer)
      field = 'id'
    end
    where(field + ' IN (?)', emails_or_ids)
  end
  
  # minimalist SQL query to get a single value from a single row
  def self.find_attribute(id, attribute)
    where(id: id).limit(1).pluck(attribute).first
  end
  
  def self.only_get_id
    select(:id).limit(1).pluck(:id).first
  end


# INSTANCE METHODS

  def nilify_blanks
    attributes.each do |column, value|
      self[column] = nil if self[column].is_a?(String) && self[column].empty?
    end
  end
  
  def update_attributes_unless_blank(attributes)
    attributes.each { |k, v| attributes.delete(k) if v.blank? }
    update(attributes)
  end
end
