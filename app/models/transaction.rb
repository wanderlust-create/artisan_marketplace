class Transaction < ApplicationRecord
  belongs_to :invoice

  validates :status, presence: true
  enum status: { successful: 0, failed: 1 }

  validates :credit_card_number, presence: true, format: { with: /\A\d{13,19}\z/, message: 'must be a valid credit card number' }
  validates :credit_card_expiration_date, presence: true, format: { with: %r{\A(0[1-9]|1[0-2])/(\d{2}|\d{4})\z}, message: 'must be in MM/YY or MM/YYYY format' }
  validate :expiration_date_cannot_be_in_the_past

  private

  def expiration_date_cannot_be_in_the_past
    return if credit_card_expiration_date.blank?

    parsed_date = begin
      Date.strptime(credit_card_expiration_date, '%m/%y')
    rescue StandardError
      nil
    end
    return unless parsed_date && parsed_date < Time.zone.today

    errors.add(:credit_card_expiration_date, 'cannot be in the past')
  end
end
