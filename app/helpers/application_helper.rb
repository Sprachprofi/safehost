module ApplicationHelper

  def email(address, options = {})
    link_to address, "mailto:#{address}", options
  end

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
  
  def social_link(url)
    (url = "mailto:" + url) if url.include?("@") and !url.starts_with?("http") and !url.starts_with?("mailto:")
    (url = "https://" + url) if url.starts_with?("www.")
    img = if url.include?("facebook.com")
      "some/facebook-blue.png"
    elsif url.include?("twitter.com")
      "some/twitter-blue.png"
    elsif url.include?("@") and !url.starts_with?("http")
      "some/email-green.png"
    elsif url.include?("vk.com")
      "some/vk.png"
    elsif url.include?("telegram.org") or url.include?("/t.me")
      "some/messenger-generic.png"
    elsif url.include?("reddit.com")
      "some/reddit.png"
    elsif url.include?("linkedin.com")
      "some/linkedin.png"
    elsif url.include?("instagram.com")
      "some/instagram.png"
    elsif url.include?("youtube.com") or url.include?("youtu.be")
      "some/youtube.png"
    elsif url.include?("github.com")
      "some/github.png"
    else
      "some/website.png"
    end
    raw("<a href=\"#{url}\" title=\"#{img[5..-5]}\">" + image_tag(img, height: 40, width: 40) + "</a>")
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

  def url(address)
    if address
      if address.include?('http') # outside link
        raw(link_to address, address, target: '_blank')
      else
        raw(link_to address, address)
      end
    end
  end
  
end
