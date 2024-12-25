require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:invoice_items) }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with_values(%i[pending shipped completed canceled]) }
  end

  describe 'data creation' do
    let(:customer) { create(:customer) }
    let(:invoice) { create(:invoice, customer: customer, status: :shipped) }

    it 'creates a valid invoice with a status' do
      expect(invoice).to be_valid
      expect(invoice.status).to eq('shipped')
    end
  end
end
