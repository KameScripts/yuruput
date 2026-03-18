class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :password, length: { minimum: 3}
end
