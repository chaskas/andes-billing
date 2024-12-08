require "application_system_test_case"

module Billing
  class InvoicesTest < ApplicationSystemTestCase
    setup do
      @invoice = billing_invoices(:one)
    end

    test "visiting the index" do
      visit invoices_url
      assert_selector "h1", text: "Invoices"
    end

    test "should create invoice" do
      visit invoices_url
      click_on "New invoice"

      fill_in "Gross total", with: @invoice.gross_total
      fill_in "Issue date", with: @invoice.issue_date
      fill_in "Issuer", with: @invoice.issuer_id
      fill_in "Net total", with: @invoice.net_total
      fill_in "Number", with: @invoice.number
      fill_in "Recipient", with: @invoice.recipient_id
      fill_in "Status", with: @invoice.status
      fill_in "Tax amount", with: @invoice.tax_amount
      fill_in "Tax rate", with: @invoice.tax_rate
      click_on "Create Invoice"

      assert_text "Invoice was successfully created"
      click_on "Back"
    end

    test "should update Invoice" do
      visit invoice_url(@invoice)
      click_on "Edit this invoice", match: :first

      fill_in "Gross total", with: @invoice.gross_total
      fill_in "Issue date", with: @invoice.issue_date
      fill_in "Issuer", with: @invoice.issuer_id
      fill_in "Net total", with: @invoice.net_total
      fill_in "Number", with: @invoice.number
      fill_in "Recipient", with: @invoice.recipient_id
      fill_in "Status", with: @invoice.status
      fill_in "Tax amount", with: @invoice.tax_amount
      fill_in "Tax rate", with: @invoice.tax_rate
      click_on "Update Invoice"

      assert_text "Invoice was successfully updated"
      click_on "Back"
    end

    test "should destroy Invoice" do
      visit invoice_url(@invoice)
      click_on "Destroy this invoice", match: :first

      assert_text "Invoice was successfully destroyed"
    end
  end
end
