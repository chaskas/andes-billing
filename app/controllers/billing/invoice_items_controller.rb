module Billing
  class InvoiceItemsController < ApplicationController
    before_action :set_invoice, only: %i[ new create ]
    before_action :set_invoice_item, only: %i[ destroy ]
    # skip_before_action :verify_authenticity_token

    def new
      @invoice_item = @invoice.invoice_items.new
    end

    # POST /invoice_items
    def create
      @invoice_item = @invoice.invoice_items.create!(invoice_item_params)

      respond_to do |format|
        if @invoice_item.save
          format.html { redirect_to edit_invoice_path(@invoice), notice: "Item was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end

    end

    # DELETE /invoices/1
    def destroy
      @invoice = Invoice.find(@invoice_item.billing_invoice_id)
      @invoice_item.destroy!
      redirect_to edit_invoice_path(@invoice), notice: "Item was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
      end

      def set_invoice_item
        @invoice_item = InvoiceItem.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def invoice_item_params
        params.require(:invoice_item).permit(:date, :duration, :kind, :unit_price, :billing_invoice_id)
      end
  end
end