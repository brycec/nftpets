class User < ApplicationRecord
  validates :name, presence: true
  validates :name, format: { with: /\A[_a-zA-Z0-9]+\z/,
    message: "can only be: _, a-z, A-Z, or 0-9"}
  validates :name, uniqueness: true
  has_secure_password
end
