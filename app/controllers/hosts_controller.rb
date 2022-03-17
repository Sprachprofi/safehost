class HostsController < InheritedResources::Base
  before_action :authenticate_user!, only: [:finished_signup]
  before_action :set_host, only: [:show, :edit, :update, :destroy]
  before_action :require_own_or_admin!, only: [:index, :show, :edit, :update, :destroy]

  def new
    if current_user
      @host = Host.new(city: current_user.city, postal_code: current_user.postal_code, country: current_user.country)
      @host.user = current_user
    else
      @host = Host.new
      @host.user = User.new
    end
  end
  
  def create
    @host = Host.new(host_params)
    @user = nil
    dont_sign_in = false
    if current_user
      @host.user_id = current_user.id
      @user = current_user
      @host.terms_of_service = true
    elsif User.where(email: user_params[:email]).exists?
      @user = User.find_by_email(user_params[:email])
      @host.user_id = @user.id
      dont_sign_in = true  # protect against hijack
    else
      @user = User.new(user_params)
      @user.city = @host.city
      @user.postal_code = @host.postal_code
      @user.country = @host.country
      @user.assign_random_password!
      @user.terms_of_service = true if @host.terms_of_service == true
      @user.skip_confirmation_notification!
      @user.save
      @host.user_id = @user.id
    end
    
    if @host.user_id and @host.save 
      flash[:notice] = I18n.t("host.success_register")
      sign_in(@user) if current_user.nil? and !dont_sign_in
      if @user.verified_phone? or dont_sign_in
        redirect_to :root and return
      else 
        redirect_to new_verification_path and return
      end
    else 
      flash[:alert] = I18n.t("host.fail_register")
      render 'new'
    end
  end
  
  def destroy
    @host.destroy
    redirect_to :root
  end
  
  def edit
  end
  
  def finished_signup
  end
  
  def update
    @host.update(host_params)
    @host.user.update(user_params)
    if request.referer.include?("/admin/")
      redirect_to "/admin/taken_hosts/#{@host.id}" and return
    else
      redirect_to :root
    end
  end
  


  private

    def host_params
      prepare_checkbox_params_for_db
      params.require(:host)
        .permit(:address, :postal_code, :city, :country, :optimal_no_guests, :max_sleeps, :max_duration, :sleep_conditions, :which_guests, :which_hosts, :description, :languages, :other_comments, :terms_of_service,
          :available, :guest_name, :guest_data, :pickup_data, :guest_end_date,
          user_attributes: [:email, :personal_name, :family_name, :mobile, :social_links, :id_or_passport_no, :terms_of_service])
    end
    
    def user_params
      params[:user][:social_links] = params[:user][:social_links].split(/\r?\n/) if params[:user] and params[:user][:social_links]
      params.require(:user).permit(:email, :personal_name, :family_name, :mobile, :contact_time, {social_links: []}, :id_or_passport_no, :terms_of_service)
    end
    
    def prepare_checkbox_params_for_db
      if params[:host]
        sleep_conditions = []
        which_guests = []
        which_hosts = []
        languages = []
        params.each do |key, value|
          if key.starts_with?('chk_sleep_') and value == '1'
            sleep_conditions << key[10..-1]
          elsif key.starts_with?('chk_guests_') and value == '1'
            which_guests << key[11..-1]
          elsif key.starts_with?('chk_hosts_') and value == '1'
            which_hosts << key[10..-1]
          elsif key.starts_with?('chk_languages_') and value == '1'
            languages << key[14..-1]
          end
        end
        params[:host][:sleep_conditions] = sleep_conditions.join(' ') if !sleep_conditions.empty?
        params[:host][:which_guests] = which_guests.join(' ') if !which_guests.empty?
        params[:host][:which_hosts] = which_hosts.join(' ') if !which_hosts.empty?
        params[:host][:languages] = languages.join(', ') if !languages.empty?
      end
    end
    
    
    def set_host
      @host = Host.find(params[:id])
    end
    
    # don't allow editing/deleting of host data that don't belong to the user
    def require_own_or_admin!
      authenticate_user! if current_user.nil?
      if (@host.user_id != current_user.id) and (!current_user.has_privilege?('match_hosts_in_city', @host.city))
        flash[:alert] = I18n.t('errors.own_or_admin')
        redirect_to '/'
      end
    end

end
