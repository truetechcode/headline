class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user && @user.authenticate(session_params[:password])
      sign_in @user
      flash[:success] = "Logged in successfully."
      redirect_to root_path
    else
      flash.now[:error] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = "Logged out successfully."
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
