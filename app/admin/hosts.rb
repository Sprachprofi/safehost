ActiveAdmin.register Host do
  
  permit_params :user_id, :address, :postal_code, :city, :country, :optimal_no_guests, :max_sleeps, :max_duration, :sleep_conditions, :which_guests, :which_hosts, :description, :languages, :other_comments, :available, :guest_name, :guest_data, :pickup_data, :guest_end_date
  
  controller do
    before_action only: :index do
      @per_page = 3 if UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city').nil?
    end

    def scoped_collection
      scope = UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city')
      if scope == 'any' or scope.nil?
        Host
      else # any specific scope
        Host.where(city: scope)
      end
    end
  end
  
end
