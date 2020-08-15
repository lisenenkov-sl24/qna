class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource User

  def notme
    render json: User.where('id != :user', user: current_resource_owner.id)
  end

  def me
    render json: current_resource_owner
  end

end