module Billing
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[ show edit update destroy ]
    before_action :get_issuers, only: %i[ new create edit ]
    before_action :get_recipients, only: %i[ new create edit ]

    # GET /invoices
    def index
      @invoices = Invoice.all
    end

    # GET /invoices/new
    def new
      @invoice = Invoice.new
      @invoice.issue_date = Date.today
      @invoice.number = Invoice.get_last_number_for_year(Date.today.year) + 1
    end

    def show
      @invoice = Invoice.find(params[:id])
    end

    # GET /invoices/1/edit
    def edit
      @invoice_item = InvoiceItem.new(billing_invoice_id: @invoice.id)
      @invoice_items = @invoice.invoice_items.all
    end

    # POST /invoices
    def create
      @invoice = Invoice.new(invoice_params)

      if @invoice.save
        redirect_to edit_invoice_path(@invoice), notice: "Invoice was successfully created."
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
        permitted = [:issue_date, :billing_issuer_id, :billing_recipient_id, :tax_rate]
        # Only allow number to be updated for existing records
        permitted << :number unless params[:action] == 'create'
        params.require(:invoice).permit(permitted)
      end

      def get_issuers
        @issuers = Issuer.order(:name)
      end

      def get_recipients
        @recipients = Recipient.order(:name)
      end
  end
end
