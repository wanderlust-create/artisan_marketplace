require 'rails_helper'

RSpec.describe Admin, type: :model do
  subject { build(:admin) } # Ensures a valid admin object is used

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid-email').for(:email) }
  end

  describe 'Secure Password' do
    it { is_expected.to have_secure_password }
  end

  describe 'Default Values' do
    it 'sets role to regular by default' do
      admin = described_class.create(email: 'john@example.com', password: 'password')
      expect(admin.role).to eq('regular')
    end
  end

  describe 'Roles' do
    it 'allows creating an admin with the super_admin role' do
      super_admin = described_class.create(email: 'super@example.com', password: 'password', role: :super_admin)
      expect(super_admin.role).to eq('super_admin')
      expect(super_admin.super_admin?).to be true
    end

    it 'allows creating an admin with the regular role' do
      regular_admin = described_class.create(email: 'regular@example.com', password: 'password', role: :regular)
      expect(regular_admin.role).to eq('regular')
      expect(regular_admin.regular?).to be true
    end

    it 'does not allow invalid roles' do
      expect do
        described_class.create!(email: 'invalid@example.com', password: 'password', role: :invalid_role)
      end.to raise_error(ArgumentError)
    end
  end
end
