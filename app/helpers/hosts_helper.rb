module HostsHelper

  def availability_state_icon(host)
    if host.available and host.user.verified_in_person
      "<i class='dark-green-dot' title='Available and previously verified in person'></i>"
    elsif host.available
      "<i class='green-dot' title='Currently available'></i>"
    else
      "<i class='red-dot' title='Not currently available'></i>"
    end
  end

end
