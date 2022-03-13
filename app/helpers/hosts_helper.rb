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

end
