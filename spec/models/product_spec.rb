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

  describe 'data creation with Faker' do
    let(:artisan) { create(:artisan) }
    let(:product) { create(:product, artisan: artisan, name: Faker::Commerce.product_name, price: 50.00, stock: 10) }

    it 'creates a valid product with Faker data' do
      expect(product).to be_valid
      expect(product.name).to be_present
      expect(product.price).to eq(50.00)
      expect(product.stock).to eq(10)
      expect(product.artisan).to eq(artisan)
    end
  end
end
