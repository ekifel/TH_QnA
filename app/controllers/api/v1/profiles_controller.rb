class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner, serializer: ProfileSerializer
  end

  def index
    render json: User.where.not(id: current_resource_owner.id), each_serializer: ProfileSerializer
  end
end
