# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorize, except: %i[login register]

  def current_user
    @user = User.find(session[:user_id]) if session[:user_id].present?
  end

  def logged_in?
    !!current_user
  end

  def authenticated?
    user = User.find_by(email: params[:username])

    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      return true
    end
    false
  end

  def authorize
    render json: { message: 'Please login to continue!' }, status: :unauthorized and return unless logged_in?
  end
end
