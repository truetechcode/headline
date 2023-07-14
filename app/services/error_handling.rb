# frozen_string_literal: true

# Handles the error response from the API.
module ErrorHandling
  def self.handle(response)
    data = JSON.parse(response.body)
    raise StandardError, "#{response.code}: #{data['message']}" if data["status"] == "error"
  end
end
