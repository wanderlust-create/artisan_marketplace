require 'rails_helper'

RSpec.describe 'API::V1::Discounts', type: :request do
  describe 'GET /api/v1/products/:product_id/discounts' do
    let(:product) { create(:product) }
    let!(:older_discount) do
      create(:discount, product:, start_date: 2.days.ago, end_date: 5.days.from_now)
    end
    let!(:newer_discount) do
      create(:discount, product:, start_date: 1.day.ago, end_date: 6.days.from_now)
    end

    it 'returns all discounts for the product sorted by start_date' do
      get "/api/v1/products/#{product.id}/discounts"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json.count).to eq(2)

      expect(json.first['id']).to eq(older_discount.id)
      expect(json.last['id']).to eq(newer_discount.id)

      expect(json.first.keys).to contain_exactly(
        'id', 'original_price', 'discount_price', 'percentage_off',
        'start_date', 'end_date', 'discount_type'
      )
    end
  end
end
