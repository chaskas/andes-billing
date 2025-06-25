# frozen_string_literal: true

require "test_helper"

module Billing
  class InvoiceItemsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @invoice = billing_invoices(:one)
      @invoice_item = billing_invoice_items(:one)
      @routes = Engine.routes
    end

    test "should get new" do
      get new_invoice_invoice_item_url(@invoice)
      assert_response :success
    end

    test "should create invoice_item with valid attributes" do
      assert_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {
          invoice_item: {
            date: Date.today,
            duration: 2,
            kind: "normal",
            unit_price: 15.99
          }
        }
      end

      assert_redirected_to edit_invoice_url(@invoice)
    end

    test "should not create invoice_item with invalid attributes" do
      assert_no_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {
          invoice_item: {
            date: nil,
            duration: nil,
            kind: nil,
            unit_price: nil
          }
        }
      end

      assert_response :unprocessable_entity
    end

    test "should create invoice_item with turbo stream format" do
      assert_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {
          invoice_item: {
            date: Date.today,
            duration: 2,
            kind: "normal",
            unit_price: 15.99
          },
          turbo_stream: "true",
          format: :turbo_stream
        }
      end

      assert_response :success
      assert_match /turbo-stream/, @response.body
      assert_match /invoice_items/, @response.body
      assert_match /invoice_totals/, @response.body
      assert_match /new_invoice_item/, @response.body
    end

    test "should create invoice_item with turbo stream format without turbo_stream parameter" do
      assert_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {
          invoice_item: {
            date: Date.today,
            duration: 2,
            kind: "normal",
            unit_price: 15.99
          },
          format: :turbo_stream
        }
      end

      assert_redirected_to edit_invoice_url(@invoice)
    end

    test "should handle empty params" do
      assert_no_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {}
      end

      assert_response :unprocessable_entity
    end

    test "should not create invoice_item with turbo stream format and invalid attributes" do
      assert_no_difference("InvoiceItem.count") do
        post invoice_invoice_items_url(@invoice), params: {
          invoice_item: {
            date: nil,
            duration: nil,
            kind: nil,
            unit_price: nil
          },
          format: :turbo_stream
        }
      end

      assert_response :success
      assert_match /turbo-stream/, @response.body
      assert_match /new_invoice_item/, @response.body
    end

    test "should remove date validation error when date is provided" do
      # First submit with all fields empty
      post invoice_invoice_items_url(@invoice), params: {
        invoice_item: {
          date: nil,
          duration: nil,
          kind: nil,
          unit_price: nil
        }
      }
      assert_response :unprocessable_entity

      # Then submit with only date filled
      post invoice_invoice_items_url(@invoice), params: {
        invoice_item: {
          date: Date.today,
          duration: nil,
          kind: nil,
          unit_price: nil
        }
      }
      assert_response :unprocessable_entity

      # The response should not contain the date validation error
      assert_select "li", { count: 0, text: "Date can't be blank" }
    end

    test "should destroy invoice_item" do
      invoice = Billing::Invoice.find(@invoice_item.billing_invoice_id)
      assert_difference("InvoiceItem.count", -1) do
        delete invoice_invoice_item_url(invoice, @invoice_item)
      end

      assert_redirected_to edit_invoice_url(invoice)
    end

    test "should destroy invoice_item with turbo stream format" do
      invoice = Billing::Invoice.find(@invoice_item.billing_invoice_id)
      assert_difference("InvoiceItem.count", -1) do
        delete invoice_invoice_item_url(invoice, @invoice_item), params: { format: :turbo_stream }
      end

      assert_response :success
      assert_match /turbo-stream/, @response.body
      assert_match /invoice_items/, @response.body
      assert_match /invoice_totals/, @response.body
      assert_match /Item was successfully removed/, @response.body
    end
  end
end
