require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_one(:artisan).through(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:discount_price) }
    it { is_expected.to validate_numericality_of(:discount_price).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    it 'validates that end_date is after start_date' do
      product = create(:product)
      invalid_discount = build(:discount, product: product, start_date: Time.zone.today, end_date: Time.zone.today - 1)

      expect(invalid_discount).not_to be_valid
      expect(invalid_discount.errors[:end_date]).to include('must be after the start date')
    end
  end

  describe 'scopes' do
    describe '.by_artisan' do
      it 'returns discounts for the specified artisan' do
        artisan = create(:artisan)
        another_artisan = create(:artisan)
        product = create(:product, artisan: artisan)
        another_product = create(:product, artisan: another_artisan)

        discount1 = create(:discount, product: product)
        discount2 = create(:discount, product: another_product)

        expect(described_class.by_artisan(artisan.id)).to include(discount1)
        expect(described_class.by_artisan(artisan.id)).not_to include(discount2)
      end
    end
  end
end
