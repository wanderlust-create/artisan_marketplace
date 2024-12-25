class Artisan < ApplicationRecord
  belongs_to :admin

  has_many :products, dependent: :destroy
  has_secure_password

  validates :store_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
end
