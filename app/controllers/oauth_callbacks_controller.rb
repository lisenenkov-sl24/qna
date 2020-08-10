class OauthCallbacksController < Devise::OmniauthCallbacksController
  rescue_from ActiveRecord::ActiveRecordError, with: :auth_error
  def github
    authorize 'GitHub'
  end

  def facebook
    authorize 'Facebook'
  end

  private

  def authorize(kind)
    @user = User.find_for_oauth!(auth_hash)

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end

  def auth_error
    redirect_to root_path, alert: 'Something went wrong'
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
