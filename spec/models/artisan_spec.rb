require 'rails_helper'

RSpec.describe Artisan, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end
    # Create a valid Admin for association
  let(:admin) { create(:admin) }

  # Create an Artisan with a valid admin_id
  subject { build(:artisan, admin: admin) }
  
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
end
