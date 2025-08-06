class Api::V1::UsersController < Api::V1::BaseController
  def show
    render json: UserSerializer.new(current_user).as_json
  end
  
  def update
    if current_user.update(user_params)
      render json: UserSerializer.new(current_user).as_json
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name)
  end
end