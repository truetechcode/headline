# frozen_string_literal: true

module Api
  module V1
    # This is a SessionsController responsible for managing session-related actions.
    class SessionsController < ApplicationController
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
        message = t("flash.success.session.loggedout")
        respond_to { |format| format.json { render json: { message: } } }
      end

      private

      def handle_successful_response(message, user)
        cookies[:remember_token] = RememberTokenGenerator.generate(user)
        respond_to { |format| format.json { render json: { message:, user: }, status: :ok } }
      end

      def handle_failed_response(message)
        respond_to { |format| format.json { render json: { error: message }, status: :unprocessable_entity } }
      end

      protected

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
