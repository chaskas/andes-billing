module Billing
  class IssuersController < ApplicationController
    before_action :set_issuer, only: %i[ edit update destroy ]

    # GET /issuers
    def index
      @issuers = Issuer.all
    end

    # GET /issuers/new
    def new
      @issuer = Issuer.new
    end

    # GET /issuers/1/edit
    def edit
    end

    # POST /issuers
    def create
      @issuer = Issuer.new(issuer_params)

      if @issuer.save
        redirect_to issuers_path, notice: "Issuer was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /issuers/1
    def update
      if @issuer.update(issuer_params)
        redirect_to issuers_path, notice: "Issuer was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /issuers/1
    def destroy
      @issuer.destroy!
      redirect_to issuers_path, notice: "Issuer was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_issuer
        @issuer = Issuer.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def issuer_params
        params.require(:issuer).permit(:name, :taxNumber, :email, :address, :phone )
      end
  end
end
