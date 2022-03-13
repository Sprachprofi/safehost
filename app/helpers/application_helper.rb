module ApplicationHelper

  def pretty_privileges(user, joiner = ', ')
    arr = []
    user.privileges.each do |priv, scope|
      if scope
        arr << (priv + ' (' + scope + ') ')
      else
        arr << priv
      end
    end
    arr.sort.join(joiner)
  end
  
  # Converts
  # "string with __link__ in the middle." to
  # "string with #{link_to('link', link_url, link_options)} in the middle."
  def string_with_link(str, link_url, link_options = {})
    match = str.match(/__([^_].{1,50}[^_])__/)
    if !match.blank?
      link_options[:target] = '_blank' if link_url.include?('http')
      raw($` + link_to($1, link_url, link_options) + $')
    else
      #raise "string_with_link: No place for __link__ given in #{str}" if Rails.env.development?
      str
    end
  end

  # Alternative to string_with_link for pure text emails
  # this produces e.g. "Please visit our group (https://...) in order to learn more."
  def string_without_link(str, link_url, link_options = {})
    match = str.match(/__([^_]{2,50})__/)
    if !match.blank?
      raw($` + $1 + ' (' + link_url + ')' + $')
    else
      # raise "string_with_link: No place for __link__ given in #{str}" if Rails.env.test?
      str
    end
  end
  
end
