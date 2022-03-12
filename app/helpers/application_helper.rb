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
end
