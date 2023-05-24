class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User successfully registered"
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.join || "Something went wrong"
      render 'new'
    end
  end

  private

def user_params
  params.require(:user).permit(:name, :email, :password)
end
end
