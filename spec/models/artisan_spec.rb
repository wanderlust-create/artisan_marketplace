require 'rails_helper'

RSpec.describe Artisan, type: :model do
  # Create a valid Admin for association
  # Create an Artisan with a valid admin_id
  subject { build(:artisan, admin: admin) }

  let(:admin) { create(:admin) }

  describe 'associations' do
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:store_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('not-an-email').for(:email) }
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end

  describe 'callbacks' do
    let(:artisan) { create(:artisan, admin: admin, active: true) }

    it 'ensures new products are created with visible: true by default' do
      product = create(:product, artisan: artisan)
      expect(product.visible).to be(true)
    end

    context 'when the artisan is deactivated' do
      before do
        create_list(:product, 2, artisan: artisan, stock: 100) # Create products for the specific context
      end

      it 'sets all associated products to visible: false' do
        artisan.update(active: false)

        artisan.products.each do |product|
          expect(product.reload.visible).to be(false)
        end
      end
    end

    context 'when the artisan is reactivated' do
      before do
        create_list(:product, 2, artisan: artisan, stock: 100) # Create products for the specific context
        artisan.update(active: false) # Deactivate first to test reactivation
      end

      it 'sets all associated products to visible: true' do
        artisan.update(active: true)

        artisan.products.each do |product|
          expect(product.reload.visible).to be(true)
        end
      end
    end
  end
end
