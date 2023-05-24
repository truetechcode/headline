class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true

  validates_length_of :password, minimum: 6, presence: true
end
