require "test_helper"

module Billing
  class BankAccountTest < ActiveSupport::TestCase
    setup do
      @bank_account = billing_bank_accounts(:one)
    end

    test "should not save bank account without holder" do
      @bank_account.holder = nil

      assert_not @bank_account.save
    end

    test "should not save bank account without name" do
      @bank_account.name = nil

      assert_not @bank_account.save
    end

    test "should not save bank account without bank name" do
      @bank_account.bank_name = nil

      assert_not @bank_account.save
    end

    test "should not save bank account without IBAN" do
      @bank_account.iban = nil

      assert_not @bank_account.save
    end

    test "should save bank account" do

      @bank_account.holder = billing_issuers(:one)
      @bank_account.name = "John Doe"
      @bank_account.bank_name = "Bank of America"
      @bank_account.iban = "US1234567890"

      assert @bank_account.save

    end
  end
end