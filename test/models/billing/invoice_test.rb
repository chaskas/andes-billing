require "test_helper"

module Billing
  class InvoiceTest < ActiveSupport::TestCase

    setup do
      @invoice = billing_invoices(:one)
    end

    test "should get invoice number 1 if no invoices on that year" do
      @invoice.issue_date = Date.new(2019, 1, 1)

      @invoice.save!

      assert_equal 1, @invoice.number
    end

    test "should set net total" do
      # Arrange
      item = InvoiceItem.new(unit_price: 10, date: Date.today, billing_invoice_id: @invoice.id)
      item.save!

      # Act
      @invoice.set_net_total

      # Assert
      assert_equal 20.0, @invoice.net_total
    end

    test "should net_total = 0 if invoice has no items" do
      @invoice.invoice_items.destroy_all

      @invoice.set_net_total

      assert_equal 0, @invoice.net_total
    end

    test "should set tax amount" do
      item = InvoiceItem.new(unit_price: 10, date: Date.today, billing_invoice_id: @invoice.id)
      item.save!

      @invoice.tax_rate = Invoice.tax_rates[:standard]

      @invoice.set_tax_amount

      assert_equal 3.8, @invoice.tax_amount
    end

    test "should set gross total" do
      item = InvoiceItem.new(unit_price: 10, date: Date.today, billing_invoice_id: @invoice.id)
      item.save!

      @invoice.tax_rate = Invoice.tax_rates[:standard]

      @invoice.set_gross_total

      assert_equal 23.8, @invoice.gross_total
    end

  end
end
