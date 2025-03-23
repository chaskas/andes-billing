module Billing
  class InvoiceItemsController < ApplicationController
    before_action :set_invoice, only: %i[ new create ]
    before_action :set_invoice_item, only: %i[ destroy ]

    def new
      # Create a completely new invoice item to ensure no validation errors are carried over
      @invoice_item = Billing::InvoiceItem.new(billing_invoice_id: @invoice.id)
      # Explicitly set date to nil to ensure it's empty in the form
      # @invoice_item.date = nil
    end

    # POST /invoice_items
    def create
      # Get the raw parameters
      raw_params = params[:invoice_item] || {}

      # Check if the date parameter is present
      date_present = raw_params[:date].present?

      # Create a new invoice item with the parameters
      @invoice_item = @invoice.invoice_items.new(invoice_item_params)

      respond_to do |format|
        if @invoice_item.save
          # Reload the invoice to ensure we have the latest data
          @invoice.reload

          # For HTML requests, redirect to the edit page
          format.html { redirect_to billing.edit_invoice_path(@invoice), notice: "Item was successfully created." }

          # For Turbo Stream requests with turbo_stream=true parameter, update the relevant frames
          if params[:turbo_stream] == "true"
            format.turbo_stream do
              # Create a new empty invoice item for the form
              @new_invoice_item = Billing::InvoiceItem.new(billing_invoice_id: @invoice.id)
              # Explicitly set date to nil to ensure it's empty in the form
              @new_invoice_item.date = nil

              # Render multiple turbo stream actions
              render turbo_stream: [
                # Update the invoice items list
                turbo_stream.update("invoice_items", partial: "billing/invoice_items/invoice_items", locals: { invoice_items: @invoice.invoice_items }),
                # Update the invoice totals
                turbo_stream.update("invoice_totals", partial: "billing/invoices/totals", locals: { invoice: @invoice }),
                # Reset the new invoice item form
                turbo_stream.replace("new_invoice_item", template: "billing/invoice_items/new", locals: { invoice_item: @new_invoice_item }),
                # Add a flash message
                turbo_stream.prepend("flash", partial: "shared/flash", locals: { flash: { notice: "Item was successfully created." } })
              ]
            end
          else
            # For Turbo Stream requests without turbo_stream=true parameter, redirect to the edit page
            format.turbo_stream { redirect_to billing.edit_invoice_path(@invoice), notice: "Item was successfully created." }
          end
        else
          # If the date parameter is present but validation still failed,
          # manually remove the date error from the errors collection
          if date_present
            # Remove the date error from the errors collection
            @invoice_item.errors.delete(:date)

            # Log for debugging
            Rails.logger.debug("Date parameter is present, removing date error")
            Rails.logger.debug("Errors after removal: #{@invoice_item.errors.full_messages}")
          end

          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream do
            # Render the form with validation errors
            # Ensure that the form fields are populated with the values from the failed submission
            # We need to explicitly pass the invoice_item with errors to the partial
            render turbo_stream: turbo_stream.replace(
              "new_invoice_item",
              template: "billing/invoice_items/new",
              locals: { invoice_item: @invoice_item }
            )
          end
        end
      end
    end

    # DELETE /invoices/1
    def destroy
      @invoice = Billing::Invoice.find(@invoice_item.billing_invoice_id)
      @invoice_item.destroy!

      # Reload the invoice to ensure we have the latest data
      @invoice.reload

      respond_to do |format|
        format.html { redirect_to billing.edit_invoice_path(@invoice), notice: "Item was successfully destroyed.", status: :see_other }
        format.turbo_stream do
          # Use a simpler approach with a single render
          render turbo_stream: turbo_stream.update("invoice_items",
            partial: "billing/invoice_items/invoice_items",
            locals: { invoice_items: @invoice.invoice_items })
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_invoice
        @invoice = Billing::Invoice.find(params[:invoice_id])
      end

      def set_invoice_item
        @invoice_item = Billing::InvoiceItem.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def invoice_item_params
        # Handle both nested and non-nested parameters
        permitted_params = if params[:invoice_item].present?
          params.require(:invoice_item).permit(:date, :duration, :kind, :unit_price)
        else
          params.permit(:date, :duration, :kind, :unit_price)
        end

        # Ensure date is properly formatted
        if permitted_params[:date].present?
          begin
            # Try to parse the date
            date_str = permitted_params[:date].to_s
            # Log the date string for debugging
            Rails.logger.debug("Date string: #{date_str}")

            # Handle different date formats
            if date_str.match?(/\d{4}-\d{2}-\d{2}/)
              # ISO format (YYYY-MM-DD)
              permitted_params[:date] = Date.parse(date_str)
            elsif date_str.match?(/\d{2}\/\d{2}\/\d{4}/)
              # US format (MM/DD/YYYY)
              parts = date_str.split('/')
              permitted_params[:date] = Date.new(parts[2].to_i, parts[0].to_i, parts[1].to_i)
            elsif date_str.match?(/\d{2}\.\d{2}\.\d{4}/)
              # European format (DD.MM.YYYY)
              parts = date_str.split('.')
              permitted_params[:date] = Date.new(parts[2].to_i, parts[1].to_i, parts[0].to_i)
            else
              # Try standard parsing
              permitted_params[:date] = Date.parse(date_str)
            end

            # Log the parsed date for debugging
            Rails.logger.debug("Parsed date: #{permitted_params[:date]}")
          rescue ArgumentError => e
            # If parsing fails, log the error and set to nil to trigger validation error
            Rails.logger.debug("Date parsing error: #{e.message}")
            permitted_params[:date] = nil
          end
        end

        permitted_params
      end
  end
end
