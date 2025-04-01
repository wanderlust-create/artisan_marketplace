class Admin < ApplicationRecord
  has_secure_password
  has_many :artisans, dependent: :destroy

  enum role: { regular: 0, super_admin: 1 }

  validates :role, presence: true
  validates :password, confirmation: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
end
