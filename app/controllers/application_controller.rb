class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  prepend_around_action :switch_locale

  def default_url_options
    { locale: I18n.locale }
  end
  
  def self.default_url_options
    { locale: I18n.locale }
  end

  def get_locale_from_browser
    http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def require_activeadmin_privileges!
    authenticate_user! if current_user.nil?
    if current_user.has_privilege?('match_hosts_in_city') or current_user.has_privilege?('help_single_user')
      # go!
    else
      flash[:alert] = 'You do not currently have ActiveAdmin access. If you believe you should have it, e.g. to do matches, write to Judith.'
      redirect_to '/'
    end
  end
  
  def require_privilege(privilege, scope = nil)
    authenticate_user! if current_user.nil? 
    if !current_user.has_privilege?(privilege, scope)
      flash[:alert] = "This function requires you to have #{privilege} privileges, which you don't have. If you believe you should have it, write to Judith."
      redirect_to('/') and return
    else
      # render
    end
  end
  
  def switch_locale(&action)
    params[:locale] = nil if not I18n.available_locales.include?(params[:locale].try(:to_sym))
    locale = params[:locale]
    if Rails.env.test?
      locale ||= :en
    else
      locale ||= (get_locale_from_browser || I18n.default_locale)
    end
    I18n.with_locale(locale, &action)
  end

end
