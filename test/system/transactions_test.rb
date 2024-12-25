require 'application_system_test_case'

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test 'visiting the index' do
    visit transactions_url
    assert_selector 'h1', text: 'Transactions'
  end

  test 'should create transaction' do
    visit transactions_url
    click_on 'New transaction'

    fill_in 'Credit card expiration date', with: @transaction.credit_card_expiration_date
    fill_in 'Credit card number', with: @transaction.credit_card_number
    fill_in 'Invoice', with: @transaction.invoice_id
    fill_in 'Status', with: @transaction.status
    click_on 'Create Transaction'

    assert_text 'Transaction was successfully created'
    click_on 'Back'
  end

  test 'should update Transaction' do
    visit transaction_url(@transaction)
    click_on 'Edit this transaction', match: :first

    fill_in 'Credit card expiration date', with: @transaction.credit_card_expiration_date
    fill_in 'Credit card number', with: @transaction.credit_card_number
    fill_in 'Invoice', with: @transaction.invoice_id
    fill_in 'Status', with: @transaction.status
    click_on 'Update Transaction'

    assert_text 'Transaction was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Transaction' do
    visit transaction_url(@transaction)
    click_on 'Destroy this transaction', match: :first

    assert_text 'Transaction was successfully destroyed'
  end
end
