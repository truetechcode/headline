# frozen_string_literal: true

# This is a UsersController responsible for managing user-related actions.
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      sign_in user

      handle_successful_response

    else
      handle_failed user.errors.full_messages.join

    end
  end

  private

  def handle_successful_response
    Rails.logger.info("User successfully registered")

    message = t("flash.success.user")
    flash[:success] = message
    redirect_to root_path
  end

  def handle_failed(message)
    log_error message
    render "new"
  end

  def log_error(message)
    flash[:error] = message
    Rails.logger.error(message)
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password, :country_code)
  end
end
