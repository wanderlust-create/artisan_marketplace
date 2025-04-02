require 'rails_helper'

RSpec.describe Discount, type: :model do
  let(:artisan) { create(:artisan) }
  let(:product) { create(:product, artisan: artisan, price: 100.0) }

  context 'validations' do # rubocop:disable RSpec/ContextWording
    it 'is valid with valid attributes for price discount' do
      discount = build(:discount, product: product, original_price: 100.0, discount_price: 80.0, discount_type: :price, start_date: Time.zone.today, end_date: Time.zone.today + 5)
      expect(discount).to be_valid
    end

    it 'is valid with valid attributes for percentage discount' do
      discount = build(:discount, product: product, original_price: 100.0, discount_price: 80.0, discount_type: :percentage, percentage_off: 20.0, start_date: Time.zone.today,
                                  end_date: Time.zone.today + 5)
      expect(discount).to be_valid
    end

    it 'is invalid without discount_price' do
      discount = build(:discount, product: product, discount_price: nil)
      expect(discount).not_to be_valid
      expect(discount.errors[:discount_price]).to be_present
    end

    it 'is invalid if percentage_off is missing for percentage type' do
      discount = build(:discount, product: product, discount_type: :percentage, percentage_off: nil)
      discount.valid?
      expect(discount.errors[:percentage_off]).to include("can't be blank")
    end

    it 'is invalid if end_date is before start_date' do
      discount = build(:discount, product: product, start_date: Date.today, end_date: Date.yesterday)
      discount.valid?
      expect(discount.errors[:end_date]).to include('must be after the start date')
    end
  end
end
