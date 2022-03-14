class VerificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_yet_verified, except: [:review, :review_from_payments, :verify_member, :reject_verification]
  #before_action -> { require_privilege('help_single_user') }, only: [:review, :review_from_payments, :verify_member, :reject_verification]

  def new
    @mobile = current_user.guess_country_code(current_user.mobile.standardise_phone_number, true) if current_user.mobile
    #if (params[:show] != 'true') and (!current_user.country.blank?) and not current_user.in_Europe?
      #@nonEU = true
      #render 'no_phone_verify' and return
    #end
  end

  #def no_phone_verify
  #end

  def do_send_pin
    mobile = params[:mobile].standardise_phone_number
    mobile = current_user.guess_country_code(mobile, false)
    send_error = false

    begin
      if (mobile != current_user.mobile and ConfirmedPhoneNumber.mobile_number_available?(mobile)) # user supplied a different number here!
        current_user.mobile = mobile
        current_user.save
        ConfirmedPhoneNumber.where(:phone_no => mobile).first_or_create(:user_id => current_user.id)
        current_user.generate_phone_pin
        current_user.send_phone_pin
      elsif mobile != current_user.mobile and not ConfirmedPhoneNumber.mobile_number_available?(mobile)
        flash.now[:alert] = I18n.t('verify.explanation_unique_number')
        render :js => "window.location = '#{new_verification_path}'" and return
      else
        current_user.generate_phone_pin
        current_user.send_phone_pin
      end
    rescue
      flash.now[:alert] = I18n.t('verify.pin_not_sent')
      render :js => "window.location = '#{new_verification_path}'" and return
    end

    respond_to do |format|
      format.js # render app/views/verifications/do_send_pin.js.erb
    end
  end

  def check
    if current_user.mobile == params[:hidden_phone_number].standardise_phone_number
      current_user.verify_phone_pin(params[:pin])
      if current_user.verified_phone? # Success!!
        UserMailer.welcome(current_user, I18n.locale).deliver_later
      end
    # notification of success/fail will be handled by Javascript
    else
      flash.now[:alert] = I18n.t('verify.number_not_match')
      redirect_to :new_verification and return
    end
    respond_to do |format|
      format.js
    end
  end

  protected

  def ensure_not_yet_verified
    if current_user.verified_phone?
      flash[:notice] = I18n.t('verify.already_verified')
      redirect_to '/'
    #elsif !current_user.confirmed?
      #flash[:alert] = I18n.t('verify.email_first') + ' ' + view_context.link_to(new_user_confirmation_url, new_user_confirmation_url, style: 'color: white')
      #redirect_to '/'
    end
  end

end
