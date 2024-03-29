# frozen_string_literal: true

# Represents a user in the application.
class User < ApplicationRecord
  has_secure_password
  has_many :articles, dependent: :destroy

  before_save { |user| user.email = email.downcase if user.email? }
  before_save { |user| user.country_code = country_code.downcase }
  before_save :create_remember_token

  validates :name, presence: true
  validates :email, presence: true
  validates :country_code, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 5, presence: true }

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
