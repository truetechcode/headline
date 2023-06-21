# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user

      handle_successful_response

    else
      handle_failed

    end
  end

  private

  def handle_successful_response
    Rails.logger.info("User successfully registered")

    respond_to do |format|
      format.html do
        flash[:success] = t("flash.success.user")
        redirect_to root_path
      end
      format.json { render json: { message: t("flash.success.user"), user: @user }, status: :created }
    end
  end

  def handle_failed
    log_error @user.errors.full_messages.join
    respond_to do |format|
      format.html { render "new" }
      format.json { render json: { error: @user.errors.full_messages.join }, status: :unprocessable_entity }
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
