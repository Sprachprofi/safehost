module HostsHelper

  def availability_state_icon(host)
    #if host.available and !host.user.nil? and host.user
      #"<i class='dark-green-dot' title='Available and previously verified in person'></i>"
    if host.available
      "<i class='green-dot' title='Currently available'></i>"
    else
      "<i class='red-dot' title='Not currently available'></i>"
    end
  end
  
  def t_array(arr, context)
    result = []
    context = context + '.' unless context.ends_with?('.') or context.ends_with?('_')
    arr.each do |item|
      result << t(context + item.downcase.gsub(/\W/, '_'))
    end
    result
  end
  
  def t_string(str, context, divider = " ")
    t_array(str.to_s.split(divider), context).join(divider)
  end
  
  # example usage: <%= f.select :role, t_for_select(ROLES_IN_GROUP, "groups.roles"), { selected: 'zmember' }, { class: 'form-control' } %>
  def t_for_select(arr, context)
    t_array(arr, context).zip(arr)
  end

end
