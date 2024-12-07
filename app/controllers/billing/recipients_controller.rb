module Billing
  class RecipientsController < ApplicationController
    before_action :set_recipient, only: %i[ edit update destroy ]

    # GET /recipients
    def index
      @recipients = Recipient.all
    end

    # GET /recipients/new
    def new
      @recipient = Recipient.new
    end

    # GET /recipients/1/edit
    def edit
    end

    # POST /recipients
    def create
      @recipient = Recipient.new(recipient_params)

      if @recipient.save
        redirect_to recipients_path, notice: "Recipient was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /recipients/1
    def update
      if @recipient.update(recipient_params)
        redirect_to recipients_path, notice: "Recipient was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /recipients/1
    def destroy
      @recipient.destroy!
      redirect_to recipients_path, notice: "Recipient was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_recipient
        @recipient = Recipient.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def recipient_params
        params.require(:recipient).permit(:name, :taxNumber, :email, :phone, :address)
      end
  end
end
