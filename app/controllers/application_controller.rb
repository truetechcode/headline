class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :api_request?
  include SessionsHelper

  def handle_unverified_request
    sign_out
    super
  end

  private
  def api_request?
    request.format.json?
  end
end
