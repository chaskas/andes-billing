module Billing
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[ edit update destroy ]

    # GET /invoices
    def index
      @invoices = Invoice.all
    end

    # GET /invoices/new
    def new
      @invoice = Invoice.new
    end

    # GET /invoices/1/edit
    def edit
    end

    # POST /invoices
    def create
      @invoice = Invoice.new(invoice_params)

      if @invoice.save
        redirect_to invoices_url, notice: "Invoice was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /invoices/1
    def update
      if @invoice.update(invoice_params)
        redirect_to invoices_url, notice: "Invoice was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /invoices/1
    def destroy
      @invoice.destroy!
      redirect_to invoices_url, notice: "Invoice was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def invoice_params
        params.require(:invoice).permit(:issue_date, :status, :number, :billing_issuer_id, :billing_recipient_id, :net_total, :tax_rate, :tax_amount, :gross_total)
      end
  end
end
