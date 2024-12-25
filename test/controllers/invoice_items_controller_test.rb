require "test_helper"

class InvoiceItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice_item = invoice_items(:one)
  end

  test "should get index" do
    get invoice_items_url
    assert_response :success
  end

  test "should get new" do
    get new_invoice_item_url
    assert_response :success
  end

  test "should create invoice_item" do
    assert_difference("InvoiceItem.count") do
      post invoice_items_url, params: { invoice_item: { invoice_id: @invoice_item.invoice_id, product_id: @invoice_item.product_id, quantity: @invoice_item.quantity, unit_price: @invoice_item.unit_price } }
    end

    assert_redirected_to invoice_item_url(InvoiceItem.last)
  end

  test "should show invoice_item" do
    get invoice_item_url(@invoice_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_item_url(@invoice_item)
    assert_response :success
  end

  test "should update invoice_item" do
    patch invoice_item_url(@invoice_item), params: { invoice_item: { invoice_id: @invoice_item.invoice_id, product_id: @invoice_item.product_id, quantity: @invoice_item.quantity, unit_price: @invoice_item.unit_price } }
    assert_redirected_to invoice_item_url(@invoice_item)
  end

  test "should destroy invoice_item" do
    assert_difference("InvoiceItem.count", -1) do
      delete invoice_item_url(@invoice_item)
    end

    assert_redirected_to invoice_items_url
  end
end
