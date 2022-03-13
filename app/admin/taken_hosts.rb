ActiveAdmin.register Host, as: 'Taken Hosts' do
  
  permit_params :user_id, :address, :postal_code, :city, :country, :optimal_no_guests, :max_sleeps, :max_duration, :sleep_conditions, :which_guests, :which_hosts, :description, :languages, :other_comments, :available, :guest_name, :guest_data, :pickup_data, :guest_end_date
  
  controller do
    #before_action only: :index do
      #@per_page = 3 if UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city').nil?
    #end

    def scoped_collection
      scope = UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city')
      if scope == 'any' or scope.nil?
        Host.taken
      else # any specific scope
        Host.taken.where(city: scope)
      end
    end
  end
  
  filter :optimal_no_guests, label: "Opt. guests"
  filter :max_duration, label: "Max nights"
  filter :which_guests_contains, label: "Guest includes", as: :select, collection: GUEST_TYPES
  filter :which_hosts_contains, label: "Host includes", as: :select, collection: HOST_TYPES
  filter :languages_contains, as: :select, collection: ["Deutsch", "English", "Russkiy", "Ukrainska", "Français", "Español", "Polski", "Other","no_common"]
  filter :sleep_conditions_contains, as: :select, collection: SLEEP_CONDITIONS
  filter :city
  filter :personal_name
  filter :family_name
  filter :user_mobile
  filter :created_at

  # quick filter by guest type
  scope :all, group: :hosting
  scope "women", :women, group: :hosting
  scope "men", :men, group: :hosting
  scope "dogs", :dogs, group: :hosting
  scope "cats", :cats, group: :hosting

  index do

    selectable_column
    column 'Name', sortable: :family_name do |host|
      s = raw(availability_state_icon(host))
      s += host.user.name
    end
    column :city
    column "Opt. guests", :optimal_no_guests
    column "Max guests", :max_sleeps
    column "Max nights", :max_duration
    column :which_guests
    column :which_hosts
    column :languages
    column "Phone" do |host|
      host.user.mobile + " - " + host.user.contact_time
    end
    column :created_at
    actions
  end
  
end
