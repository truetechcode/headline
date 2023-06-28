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

      handle_successful_response user

    else
      handle_failed user.errors.full_messages.join

    end
  end

  private

  def handle_successful_response(user)
    Rails.logger.info("User successfully registered")

    respond_to do |format|
      message = t("flash.success.user")
      format.html do
        flash[:success] = message
        redirect_to root_path
      end
      format.json { render json: { message:, user: }, status: :created }
    end
  end

  def handle_failed(message)
    log_error message
    respond_to do |format|
      format.html { render "new" }
      format.json { render json: { error: message }, status: :unprocessable_entity }
    end
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
