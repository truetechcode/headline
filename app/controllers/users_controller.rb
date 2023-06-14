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
      redirect_to root_path
    else
      Rails.logger.error(@user.errors.full_messages[0])
      flash[:error] = @user.errors.full_messages.join || "Something went wrong"
      render 'new'
    end
  end

  private

def user_params
  params.require(:user).permit(:name, :email, :password, :country_code)
end
end
