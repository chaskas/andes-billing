require "test_helper"

module Billing
  class InvoicesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @invoice = billing_invoices(:one)
    end

    test "should get index" do
      get invoices_url
      assert_response :new
    end

    test "should get new" do
      get new_invoice_url
      assert_response :success
    end

    test "should create invoice" do
      assert_difference("Invoice.count") do
        post invoices_url, params: { invoice: { gross_total: @invoice.gross_total, issue_date: @invoice.issue_date, billing_issuer_id: @invoice.issuer.id, net_total: @invoice.net_total, number: @invoice.number, billing_recipient_id: @invoice.recipient.id, status: @invoice.status, tax_amount: @invoice.tax_amount, tax_rate: @invoice.tax_rate } }
      end

      last_invoice_created = Billing::Invoice.order(created_at: :asc).last

      assert_redirected_to edit_invoice_url(last_invoice_created.id)
    end

    test "should get edit" do
      get edit_invoice_url(@invoice)
      assert_response :success
    end

    test "should update invoice" do
      patch invoice_url(@invoice), params: { invoice: { gross_total: @invoice.gross_total, issue_date: @invoice.issue_date, issuer_id: @invoice.issuer.id, net_total: @invoice.net_total, number: @invoice.number, recipient_id: @invoice.recipient.id, status: @invoice.status, tax_amount: @invoice.tax_amount, tax_rate: @invoice.tax_rate } }
      assert_redirected_to invoices_url
    end

    test "should destroy invoice" do
      assert_difference("Invoice.count", -1) do
        delete invoice_url(@invoice)
      end

      assert_redirected_to invoices_url
    end
  end
end
