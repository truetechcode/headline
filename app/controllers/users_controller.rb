# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      Rails.logger.info("User successfully registered")
      flash[:success] = "User successfully registered"

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: { message: "User successfully registered", user: @user }, status: :created }
      end
    else
      Rails.logger.error(@user.errors.full_messages.join)
      flash[:error] = @user.errors.full_messages.join || "Something went wrong"

      respond_to do |format|
        format.html { render "new" }
        format.json { render json: { error: @user.errors.full_messages.join }, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :country_code)
  end
end
