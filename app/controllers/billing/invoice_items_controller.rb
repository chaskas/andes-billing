module Billing
  class InvoiceItemsController < ApplicationController
    before_action :set_invoice, only: %i[ create ]
    before_action :set_invoice_item, only: %i[ destroy ]
    skip_before_action :verify_authenticity_token

    # POST /invoice_items
    def create
      puts "invoice_item_params: #{invoice_item_params}"
      @invoice_item = InvoiceItem.new(invoice_item_params)

      if @invoice_item.save
        redirect_to edit_invoice_path(@invoice), notice: "Invoice item was successfully created."
      else
        puts "invoice_item.errors: #{@invoice_item}"
      end
    end

    # DELETE /invoices/1
    def destroy
      @invoice = Invoice.find(@invoice_item.billing_invoice_id)
      @invoice_item.destroy!
      redirect_to edit_invoice_path(@invoice), notice: "Invoice was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:invoice_item][:billing_invoice_id])
      end

      def set_invoice_item
        @invoice_item = InvoiceItem.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def invoice_item_params
        params.require(:invoice_item).permit(:date, :duration, :type, :amount, :unit_price, :billing_invoice_id)
      end
  end
end