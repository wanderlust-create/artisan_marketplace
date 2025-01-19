require 'rails_helper'

RSpec.feature 'UserViewsInvoice', type: :feature do
  let(:customer) { FactoryBot.create(:customer) }
  let(:artisan) { FactoryBot.create(:artisan) }
  let(:invoice) { FactoryBot.create(:invoice, customer: customer, status: :pending) }

  before do
    # Create 5 products and corresponding invoice items using Faker
    5.times do
      product = FactoryBot.create(:product,
                                  name: Faker::Commerce.product_name,
                                  description: Faker::Lorem.sentence,
                                  price: Faker::Commerce.price(range: 10.0..100.0, as_string: false),
                                  artisan: artisan)
      FactoryBot.create(:invoice_item,
                        invoice: invoice,
                        product: product,
                        quantity: Faker::Number.between(from: 1, to: 10),
                        unit_price: product.price)
    end
  end

  scenario 'User views an invoice with 5 dynamically generated items' do
    visit invoice_path(invoice)

    # Verify invoice details
    expect(page).to have_content("Invoice ##{invoice.id}")
    expect(page).to have_content('Status: Pending')

    # Verify the dynamically created invoice items
    invoice.invoice_items.each do |item|
      expect(page).to have_selector("tr#invoice-item-#{item.id}")
      expect(page).to have_content(item.product.name)
      expect(page).to have_content(item.product.description)
      within("tr#invoice-item-#{item.id}") do
        expect(page).to have_content(item.quantity.to_s)
        expect(page).to have_content(item.unit_price)
      end
    end
  end

  scenario 'User views an invoice with no items and sees the appropriate message' do
    empty_invoice = FactoryBot.create(:invoice, customer: customer, status: :pending)

    visit invoice_path(empty_invoice)

    # Verify the invoice details
    expect(page).to have_content("Invoice ##{empty_invoice.id}")
    expect(page).to have_content('Status: Pending')

    # Verify the no items message
    expect(page).to have_content('No items on this invoice.')
  end
end
