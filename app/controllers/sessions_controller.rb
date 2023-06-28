# frozen_string_literal: true

# This is a SessionsController responsible for managing session-related actions.
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      sign_in user
      handle_successful_response t("flash.success.session.loggedin"), user
    else
      handle_failed_response t("flash.fail.session")
    end
  end

  def destroy
    sign_out

    respond_to do |format|
      message = t("flash.success.session.loggedout")
      format.html do
        flash[:success] = message
        redirect_to root_path
      end
      format.json { render json: { message: } }
    end
  end

  private

  def handle_successful_response(message, user)
    respond_to do |format|
      format.html do
        flash[:success] = message
        redirect_to root_path
      end
      format.json do
        cookies[:remember_token] = RememberTokenGenerator.generate(user)
        render json: { message:, user: }, status: :ok
      end
    end
  end

  def handle_failed_response(message)
    flash.now[:error] = message
    respond_to do |format|
      format.html { render "new" }
      format.json { render json: { error: message }, status: :unprocessable_entity }
    end
  end

  protected

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
