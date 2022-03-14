# encoding: utf-8

class PagesController < ApplicationController

  def e_404
    logger.warn "Error: Page Not Found: '#{request.fullpath}' (#{request.domain}). Route not found."
    if params[:format] and ["gif", "png", "json", "text", "csv"].include?(params[:format].downcase)
      head 404
    else
      render 'error_404', status: 404, formats: :html
    end
  end
    
  def error_400
    if request.fullpath and (request.fullpath.include?("ensaluto") or request.fullpath.include?("sign_in"))
      logger.warn "Error: Tried logging in as #{params[:user][:email]} at #{request.fullpath} (#{request.domain})"
    else
      logger.warn "Error: Invalid form submission to #{request.fullpath} (#{request.domain}) by user #{current_user.try(:id)}"
    end
    render status: 400, formats: :html
  end
  
####################################

  def data_privacy
  end
  
  def export_my_data
    if UserMailer.export_data(current_user, User.export_personal_information(current_user.id)).deliver_later
      flash[:notice] = "All data that is associated with your account has been exported and sent to your email address."
    else
      flash[:alert] = 'There was an error exporting your data; please contact tech@safehost.space for technical help.'
    end
    redirect_to :index
  end

  def index
  end
  
  def legal
  end

end
