# frozen_string_literal: true

module Api
  module V1
    # This is a UsersController responsible for managing user-related actions.
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          sign_in user

          handle_successful_response user

        else
          handle_fail_response user.errors.full_messages.join

        end
      end

      private

      def handle_successful_response(user)
        Rails.logger.info("User successfully registered")
        message = t("flash.success.user")
        respond_to { |format| format.json { render json: { message:, user: }, status: :created } }
      end

      def handle_fail_response(message)
        Rails.logger.error(message)
        respond_to { |format| format.json { render json: { errors: message }, status: :unprocessable_entity } }
      end

      protected

      def user_params
        params.require(:user).permit(:name, :email, :password, :country_code)
      end
    end
  end
end
