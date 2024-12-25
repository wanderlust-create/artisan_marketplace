class Admin < ApplicationRecord
  has_secure_password
  has_many :artisans, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
end
