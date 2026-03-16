require "test_helper"

module Billing
  class InvoiceTest < ActiveSupport::TestCase

    setup do
      @invoice = billing_invoices(:one)
      @issuer = billing_issuers(:one)
      @recipient = billing_recipients(:one)
    end

    test "should get invoice number 1 if no invoices on that year" do
      @invoice.issue_date = Date.new(2019, 1, 1)

      @invoice.save!

      assert_equal 1, @invoice.number
    end

    test "should get invoice number 2 if there is an invoice on that year" do
      @invoice.issue_date = Date.new(2019, 1, 1)
      @invoice.save!

      new_invoice = Invoice.new(issue_date: Date.new(2019, 1, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)
      new_invoice.save!

      assert_equal 2, new_invoice.number
    end

    test "should set net total" do
      # Arrange
      item = InvoiceItem.new(unit_price: 10, date: Date.today, duration: 10, kind: :normal, billing_invoice_id: @invoice.id)
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
      item = InvoiceItem.new(unit_price: 10, date: Date.today, duration: 10, kind: :normal, billing_invoice_id: @invoice.id)
      item.save!

      @invoice.tax_rate = Invoice.tax_rates[:standard]

      @invoice.set_tax_amount

      assert_equal 3.8, @invoice.tax_amount
    end

    test "should set gross total" do
      item = InvoiceItem.new(unit_price: 10, date: Date.today, duration: 10, kind: :normal, billing_invoice_id: @invoice.id)
      item.save!

      @invoice.tax_rate = Invoice.tax_rates[:standard]

      @invoice.set_gross_total

      assert_equal 23.8, @invoice.gross_total
    end

    # --- Net total edge cases ---

    test "net_total with multiple items sums all unit_prices" do
      @invoice.invoice_items.destroy_all

      [10, 20, 30].each do |price|
        InvoiceItem.create!(unit_price: price, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)
      end

      @invoice.reload.set_net_total
      assert_equal 60, @invoice.net_total
    end

    test "adding an item recalculates net_total via callback" do
      @invoice.invoice_items.destroy_all
      @invoice.update!(net_total: 0, tax_amount: 0, gross_total: 0)

      InvoiceItem.create!(unit_price: 25, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      assert_equal 25, @invoice.net_total
    end

    test "removing an item recalculates net_total via callback" do
      @invoice.invoice_items.destroy_all
      item1 = InvoiceItem.create!(unit_price: 40, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)
      InvoiceItem.create!(unit_price: 60, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      item1.destroy!

      @invoice.reload
      assert_equal 60, @invoice.net_total
    end

    # --- Tax amount for all rates ---

    test "tax_amount is 0 for exempt rate" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.tax_rate = Invoice.tax_rates[:exempt]
      @invoice.set_tax_amount

      assert_equal 0, @invoice.tax_amount
    end

    test "tax_amount is 7% for reduced rate" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.tax_rate = Invoice.tax_rates[:reduced]
      @invoice.set_tax_amount

      assert_equal 7, @invoice.tax_amount
    end

    test "tax_amount is 19% for standard rate" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.tax_rate = Invoice.tax_rates[:standard]
      @invoice.set_tax_amount

      assert_equal 19, @invoice.tax_amount
    end

    # --- Tax rate change callback ---

    test "changing tax_rate recalculates tax_amount and gross_total" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.update!(tax_rate: Invoice.tax_rates[:exempt])
      assert_equal 0, @invoice.reload.tax_amount
      assert_equal 100, @invoice.gross_total

      @invoice.update!(tax_rate: Invoice.tax_rates[:standard])
      @invoice.reload
      assert_equal 19, @invoice.tax_amount
      assert_equal 119, @invoice.gross_total
    end

    # --- Gross total ---

    test "gross_total equals net_total when tax is exempt" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.tax_rate = Invoice.tax_rates[:exempt]
      @invoice.set_gross_total

      assert_equal 100, @invoice.gross_total
    end

    test "gross_total is net_total plus 19% for standard rate" do
      @invoice.invoice_items.destroy_all
      InvoiceItem.create!(unit_price: 100, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      @invoice.tax_rate = Invoice.tax_rates[:standard]
      @invoice.set_gross_total

      assert_equal 119, @invoice.gross_total
    end

    # --- Invoice numbering ---

    test "first invoice of a new year gets number 1" do
      new_invoice = Invoice.create!(issue_date: Date.new(2030, 6, 15), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)
      assert_equal 1, new_invoice.number
    end

    test "sequential numbering within the same year" do
      Invoice.create!(issue_date: Date.new(2031, 1, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)
      Invoice.create!(issue_date: Date.new(2031, 3, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)
      third = Invoice.create!(issue_date: Date.new(2031, 6, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)

      assert_equal 3, third.number
    end

    test "numbering resets for a different year" do
      Invoice.create!(issue_date: Date.new(2032, 12, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)
      first_of_next_year = Invoice.create!(issue_date: Date.new(2033, 1, 1), billing_issuer_id: @issuer.id, billing_recipient_id: @recipient.id)

      assert_equal 1, first_of_next_year.number
    end

    # --- Callback chain ---

    test "creating an item updates all invoice totals in one cycle" do
      @invoice.invoice_items.destroy_all
      @invoice.update!(tax_rate: Invoice.tax_rates[:standard], net_total: 0, tax_amount: 0, gross_total: 0)

      InvoiceItem.create!(unit_price: 50, date: Date.today, duration: 1, kind: :normal, billing_invoice_id: @invoice.id)

      @invoice.reload
      assert_equal 50, @invoice.net_total
      assert_equal 9.5, @invoice.tax_amount
      assert_equal 59.5, @invoice.gross_total
    end

  end
end
