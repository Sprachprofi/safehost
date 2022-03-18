ActiveAdmin.register Host, as: 'Available Host' do
  includes :user
  
  actions :index, :show, :destroy
  
  permit_params :user_id, :address, :postal_code, :city, :country, :optimal_no_guests, :max_sleeps, :max_duration, :sleep_conditions, :which_guests, :which_hosts, :description, :languages, :other_comments, :available, :guest_name, :guest_data, :pickup_data, :guest_end_date
  
  controller do
    helper HostsHelper
    helper ApplicationHelper
    #before_action only: :index do
      #@per_page = 3 if UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city').nil?
    #end

    def scoped_collection
      scope = UserPrivilege.get_scope_of_privilege(current_user, 'match_hosts_in_city')
      if scope == 'any' or scope.nil?
        Host.available
      else # any specific scope
        Host.available.where("city ILIKE '%#{scope}%'")
      end
    end
  end
  
  filter :optimal_no_guests
  filter :max_duration
  filter :which_guests_contains, label: proc{I18n.t("admin.guest_includes")}, as: :select, collection: -> {t_for_select(GUEST_TYPES, "host.person_type")}
  filter :which_hosts_contains, label: proc{I18n.t("admin.host_includes")}, as: :select, collection: -> {t_for_select(HOST_TYPES, "host.person_type")}
  filter :languages_contains, label: proc{I18n.t("admin.languages_include")}, as: :select, collection: ["Deutsch", "English", "русский", "украї́нська", "Français", "Español", "Polski", "Misc Slavic", "Other", "no_common"]
  filter :sleep_conditions_contains, label: proc{I18n.t("admin.sleep_includes")}, as: :select, collection: -> {t_for_select(SLEEP_CONDITIONS, "host.sleep_cond")}
  filter :city
  filter :personal_name
  filter :family_name
  filter :user_mobile
  filter :created_at
  
  config.batch_actions = false

  # quick filter by guest type
  scope :all, group: :hosting
  scope(proc {I18n.t("host.person_type.women")}, :women, group: :hosting)
  scope(proc {I18n.t("host.person_type.xmen")}, :men, group: :hosting)
  scope(proc {I18n.t("host.person_type.couple")}, :couple, group: :hosting)
  scope(proc {I18n.t("host.person_type.babies")}, :babies, group: :hosting)
  scope(proc {I18n.t("host.person_type.dogs")}, :dogs, group: :hosting)
  scope(proc {I18n.t("host.person_type.cats")}, :cats, group: :hosting)
  scope(">4", group: :hosting) { |scope| scope.where("optimal_no_guests > 4") }
 
  index title: proc{I18n.t("admin.available_hosts")} do
    selectable_column
    column 'Name', sortable: :family_name do |host|
      s = raw(availability_state_icon(host))
      s += host.user.name
    end
    column :city
    column I18n.t("admin.opt_guests"), :optimal_no_guests
    column I18n.t("admin.max_guests"), :max_sleeps
    column I18n.t("admin.max_nights"), :max_duration
    column I18n.t("admin.welcome_guests") do |host|
      t_string(host.which_guests, "host.person_type")
    end
    column I18n.t("activerecord.models.host") do |host|
      t_string(host.which_hosts, "host.person_type")
    end
    column :languages
    column :mobile do |host|
      host.user.mobile.to_s + " - " + host.user.contact_time.to_s
    end
    column I18n.t("admin.comments") do |host|
      s = host.description.to_s.truncate(200, separator: ' ')
      (s += "<br>" + host.other_comments.to_s.truncate(200, separator: ' ')) if !host.other_comments.blank?
      raw(s)
    end
    column :created_at
    actions defaults: false do |host|
      span item t("active_admin.view"), admin_available_host_path(host)
      span item t("active_admin.edit"), edit_host_path(host)
    end
  end
  
  show title: proc{|host| host.user.name }  do
    panel I18n.t("admin.found_guest") do
      render partial: '/hosts/found_guest', locals: { host: available_host }
    end
    panel I18n.t("admin.contact_data") do
      para available_host.user.name
      para link_to("mailto:#{available_host.user.email}", available_host.user.email)
      para available_host.user.mobile 
      render partial: '/users/social_links', locals: { user: available_host.user }
      para I18n.t("admin.host_is") + t_string(available_host.which_hosts, "host.person_type")
    end
    attributes_table title: I18n.t("admin.hosting_data") do 
      row :available
      row :address do |host|
        [host.address.to_s, host.postal_code.to_s, host.city.to_s, host.country_name].join(", ")
      end
      row :optimal_no_guests
      row :max_sleeps
      row :max_duration
      row :sleep_conditions do |host|
        t_string(host.sleep_conditions, "host.sleep_cond")
      end
      row :description
      row :which_guests do |host|
        t_string(host.which_guests, "host.person_type")
      end
      row :languages 
      row :other_comments
    end
    active_admin_comments
  end
  
  form partial: 'hosts/form'
  
end
