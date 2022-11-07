class UsersController < ApplicationController
  before_action :load_user, only: %i[show update]

  def index
    render json: { users: User.all }, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created!' }, status: :ok
    else
      render json: { message: 'User creation failed!' }, status: :bad_request
    end
  end

  def update
    @user.update(user_params)

    if @user.errors.present?
      render json: { message: 'Could not update user!', error: @user.errors.full_messages }, status: :bad_request
    else
      render json: { message: 'User updated successfully!' }, status: :ok
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email)
  end

  def load_user
    @user = User.find_by(params[:id])
    if @user.blank?
      render json: { message: 'Resource not found!' }, status: :not_found and return
    end
  end
end
