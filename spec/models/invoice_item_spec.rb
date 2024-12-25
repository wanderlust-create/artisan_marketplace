require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:invoice) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with_values(%i[pending shipped completed canceled]) }
  end

  describe 'valid data creation' do
    let(:invoice_item) { create(:invoice_item, status: :shipped) }

    it 'creates a valid invoice item with Faker' do
      expect(invoice_item).to be_valid
      expect(invoice_item.status).to eq('shipped')
    end
  end
end