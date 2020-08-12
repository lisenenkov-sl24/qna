class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url, alert: exception.message }
      format.js { render status: 403, js: "alert('#{helpers.j(exception.message)}')" }
    end
  end

  check_authorization unless: :skip_authorization?

  private

  def skip_authorization?
    return true if devise_controller?

    false
  end
end
