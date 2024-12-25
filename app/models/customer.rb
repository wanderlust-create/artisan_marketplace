class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
end
