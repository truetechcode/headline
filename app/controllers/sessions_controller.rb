# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user&.authenticate(session_params[:password])
      sign_in @user
      handle_successful_response
    else
      handle_failed_response
    end
  end

  def destroy
    sign_out

    respond_to do |format|
      format.html do
        flash[:success] = t("flash.success.session.loggedout")
        redirect_to root_path
      end
      format.json { render json: { message: t("flash.success.session.loggedout") } }
    end
  end

  private

  def handle_successful_response
    respond_to do |format|
      format.html do
        flash[:success] = t("flash.success.session.loggedin")
        redirect_to root_path
      end
      format.json do
        cookies[:remember_token] = token_hash
        render json: { message: t("flash.success.session.loggedin"), user: @user }, status: :ok
      end
    end
  end

  def token_hash
    {
      value: @user.remember_token,
      httponly: true,
      secure: Rails.env.production?,
      expires: 1.week.from_now
    }
  end

  def handle_failed_response
    flash.now[:error] = t("flash.fail.session")
    respond_to do |format|
      format.html { render "new" }
      format.json { render json: { error: t("flash.fail.session") }, status: :unprocessable_entity }
    end
  end

  protected

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
