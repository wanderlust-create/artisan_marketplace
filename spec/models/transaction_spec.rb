require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:invoice) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:credit_card_number) }
    it { is_expected.to validate_presence_of(:credit_card_expiration_date) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with_values([:successful, :failed]) }
  end
end