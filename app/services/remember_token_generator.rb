# frozen_string_literal: true

# Generates remember token hash for user session
class RememberTokenGenerator
  def self.generate(user)
    {
      value: user.remember_token,
      httponly: true,
      secure: Rails.env.production?,
      expires: 1.week.from_now
    }
  end
end
