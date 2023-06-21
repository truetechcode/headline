# frozen_string_literal: true

# This is the base mailer class for your application.
# All mailers in your application should inherit from this class.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
