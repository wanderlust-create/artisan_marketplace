require 'application_system_test_case'

class InvoiceItemsTest < ApplicationSystemTestCase
  setup do
    @invoice_item = invoice_items(:one)
  end

  test 'visiting the index' do
    visit invoice_items_url
    assert_selector 'h1', text: 'Invoice items'
  end

  test 'should create invoice item' do
    visit invoice_items_url
    click_on 'New invoice item'

    fill_in 'Invoice', with: @invoice_item.invoice_id
    fill_in 'Product', with: @invoice_item.product_id
    fill_in 'Quantity', with: @invoice_item.quantity
    fill_in 'Unit price', with: @invoice_item.unit_price
    click_on 'Create Invoice item'

    assert_text 'Invoice item was successfully created'
    click_on 'Back'
  end

  test 'should update Invoice item' do
    visit invoice_item_url(@invoice_item)
    click_on 'Edit this invoice item', match: :first

    fill_in 'Invoice', with: @invoice_item.invoice_id
    fill_in 'Product', with: @invoice_item.product_id
    fill_in 'Quantity', with: @invoice_item.quantity
    fill_in 'Unit price', with: @invoice_item.unit_price
    click_on 'Update Invoice item'

    assert_text 'Invoice item was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Invoice item' do
    visit invoice_item_url(@invoice_item)
    click_on 'Destroy this invoice item', match: :first

    assert_text 'Invoice item was successfully destroyed'
  end
end
