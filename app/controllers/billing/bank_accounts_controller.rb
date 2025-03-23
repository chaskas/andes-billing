module Billing
  class BankAccountsController < ApplicationController

    # POST /bank_accounts
    def create
      @bank_account = BankAccount.new(bank_account_params)

      if @bank_account.save
        redirect_to bank_accounts_path, notice: "Bank account was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end


  end
end
