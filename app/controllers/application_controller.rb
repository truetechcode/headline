# frozen_string_literal: true

# This is a top-level documentation comment for the ApplicationController class.
class ApplicationController < ActionController::Base
  include SessionsHelper

  prepend_before_action :verify_authenticity_token, if: :api_request?
  protect_from_forgery

  def handle_unverified_request
    sign_out
    super
  end

  private

  def api_request?
    request.format.json?
  end
end
