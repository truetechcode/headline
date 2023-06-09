class User < ApplicationRecord
  has_secure_password
  has_many :articles

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true
  validates :email, presence: true

  validates_length_of :password, minimum: 5, presence: true

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
