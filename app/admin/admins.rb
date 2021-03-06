ActiveAdmin.register User, as: 'Admin' do
  controller do
    before_action -> { require_privilege('assign_privileges') }

    def scoped_collection
      User
    end
  end

  #filter :privileges_privilege_eq, label: 'Privilege', as: :select, collection: UserPrivilege.list
  filter :country, as: :select, collection: ISO3166::Country.translations('EN').invert
  filter :email
  filter :personal_name
  filter :family_name
  filter :created_at

  # config.batch_actions = false

  batch_action :remove_all_privileges do |ids|
    batch_action_collection.find(ids).each do |user|
      UserPrivilege.remove_all_privileges(user)
      #Store.admin_log(current_user, "removed all admin privileges of #{user.email}.")
    end
    redirect_to collection_path, alert: 'The selected users have been removed as admins.'
  end

  batch_action :remove_privilege, form: {
    privilege: UserPrivilege.list
  } do |ids, inputs|
    # inputs is a hash of all the form fields you requested do |ids|
    batch_action_collection.find(ids).each do |user|
      UserPrivilege.remove_privilege(user, inputs['privilege'])
      #Store.admin_log(current_user, "removed #{inputs['privilege']} privilege from #{user.email}.")
    end
    redirect_to collection_path, alert: "The selected users have lost the privilege to #{inputs['privilege']}."
  end

  batch_action :add_privilege, form: {
    privilege: UserPrivilege.list
  } do |ids, inputs|
    # inputs is a hash of all the form fields you requested do |ids|
    batch_action_collection.find(ids).each do |user|
      UserPrivilege.assign_privilege(user, inputs['privilege'])
      #Store.admin_log(current_user, "gave privilege #{inputs['privilege']} to #{user.email}.")
    end
    redirect_to collection_path, alert: "The selected users have gained the privilege to #{inputs['privilege']}."
  end
  
  batch_action :reset_password do |ids|
    # inputs is a hash of all the form fields you requested do |ids|
    batch_action_collection.find(ids).each do |user|
      user.confirm
      user.password = 'AllTogetherNow!'
      user.save
      #Store.admin_log(current_user, "gave privilege #{inputs['privilege']} to #{user.email}.")
    end
    redirect_to collection_path, alert: "The selected users' password has been reset to 'AllTogetherNow!'"
  end

  action_item :dashboard do
    link_to 'Back to dashboard', root_path
  end
  
  scope :admins, default: true
  scope :all

  index do
    selectable_column
    column 'Name', sortable: :family_name do |user|
      user.name
    end
    column :email
    column :city
    column 'Abilities' do |user|
      raw(pretty_privileges(user))
    end
    column :created_at
    actions
  end
end
