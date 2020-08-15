class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url, alert: exception.message }
      format.js { render status: 403, js: "alert('#{helpers.j(exception.message)}')" }
      format.json { render status: 403, json: { error: exception.message } }
    end
  end

  check_authorization unless: :devise_controller?
end
