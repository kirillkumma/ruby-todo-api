# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: { message: "Can't be blank" },
                    uniqueness: { message: 'Has already been taken' }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP,
                      message: 'Invalid format' }
  validates :name, presence: { message: "Can't be blank" }
  validates :password, presence: true,
                       length: { minimum: 6, message: 'Too short (minimum is 6 characters)' }
end
