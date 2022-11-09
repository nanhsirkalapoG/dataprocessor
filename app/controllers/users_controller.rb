# frozen_string_literal: true

class UsersController < ApplicationController
  def login
    render json: { message: 'Logged in successfully!' }, status: :ok if authenticate

    render json: { message: 'Invalid username/password!' }, status: :unauthorized
  end

  def logout
    session[:user_id] = nil

    render json: { message: 'Logged out successfully!' }, status: :ok
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
    params.permit(:first_name, :last_name, :email, :password)
  end
end
