require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    subject { create(:admin) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('not-an-email').for(:email) }
  end

  describe 'secure password' do
    it { is_expected.to have_secure_password }
  end
end
