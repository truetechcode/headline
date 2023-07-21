# frozen_string_literal: true

# This is a SessionsController responsible for managing session-related actions.
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      sign_in user
      handle_successful_response t("flash.success.session.loggedin")
    else
      handle_failed_response t("flash.fail.session")
    end
  end

  def destroy
    sign_out

    message = t("flash.success.session.loggedout")
    flash[:success] = message
    redirect_to root_path
  end

  private

  def handle_successful_response(message)
    flash[:success] = message
    redirect_to root_path
  end

  def handle_failed_response(message)
    flash.now[:error] = message
    render "new"
  end

  protected

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
