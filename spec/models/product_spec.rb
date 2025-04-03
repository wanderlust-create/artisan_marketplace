require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:artisan) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:invoices).through(:invoice_items) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:stock) }
    it { is_expected.to validate_numericality_of(:stock).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '.with_active_discounts' do
    subject(:products) { described_class.with_active_discounts }

    let(:artisan) { create(:artisan) }
    let(:product_with_discount) { create(:product, artisan:) }
    let(:product_without_discount) { create(:product, artisan:) }

    before do
      create(:discount, product: product_with_discount,
                        start_date: Time.zone.today - 1,
                        end_date: Time.zone.today + 1)

      create(:discount, product: product_without_discount,
                        start_date: 2.weeks.ago,
                        end_date: 1.week.ago)
    end

    it 'includes products with active discounts' do
      expect(products).to include(product_with_discount)
    end

    it 'excludes products without active discounts' do
      expect(products).not_to include(product_without_discount)
    end

    it 'excludes products with discounts that start in the future' do
      future_product = create(:product, artisan:)
      create(:discount, product: future_product,
                        start_date: 1.day.from_now,
                        end_date: 1.week.from_now)

      expect(products).not_to include(future_product)
    end
  end
end
