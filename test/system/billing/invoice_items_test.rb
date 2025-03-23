# frozen_string_literal: true

require "test_helper"
require_relative "../../application_system_test_case"

module Billing
  class InvoiceItemsTest < ApplicationSystemTestCase
    setup do
      @invoice = billing_invoices(:one)
    end

    test "creating an invoice item" do
      visit billing.edit_invoice_path(@invoice)

      # Fill in the form with valid data
      # Use a specific date to avoid any issues with date formatting
      fill_in "invoice_item[date]", with: "2025-03-23"
      fill_in "Duration", with: 2
      select "Normal", from: "Kind"
      fill_in "Unit price", with: 15.99

      # Submit the form
      click_on "Add"

      # Assert that the item was created
      assert_text "Item was successfully created"
    end

    test "validation errors are cleared after successful submission" do
      visit billing.edit_invoice_path(@invoice)

      # Submit the form without a date (should show validation error)
      fill_in "Duration", with: 2
      select "Normal", from: "Kind"
      fill_in "Unit price", with: 15.99
      click_on "Add"

      # Assert that validation error is shown
      assert_text "prohibited this item from being saved"
      assert_text "Date can't be blank"

      # Fill in the date and submit again
      fill_in "invoice_item[date]", with: "2025-03-23"
      click_on "Add"

      # Assert that the validation error is gone
      assert_no_text "prohibited this item from being saved"
      assert_no_text "Date can't be blank"

      # Assert that the form is reset
      assert_field "Date", with: ""
    end

    test "validation errors are updated correctly when filling in previously unfilled fields" do
      visit billing.edit_invoice_path(@invoice)

      # Fill in the form with valid data
      fill_in "invoice_item[date]", with: "2025-03-23"
      fill_in "Duration", with: 2
      select "Normal", from: "Kind"
      fill_in "Unit price", with: 15.99

      # Submit the form
      click_on "Add"

      # Assert that the item was created
      assert_text "Item was successfully created"
    end
  end
end
