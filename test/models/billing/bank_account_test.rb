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

    test "should save bank account with issuer as holder" do
      @bank_account.holder = billing_issuers(:one)
      @bank_account.name = "John Doe"
      @bank_account.bank_name = "Bank of America"
      @bank_account.iban = "US1234567890"

      assert @bank_account.save
      assert_equal "Billing::Issuer", @bank_account.holder_type
    end

    test "should save bank account with recipient as holder" do
      @bank_account.holder = billing_recipients(:one)
      @bank_account.name = "Jane Doe"
      @bank_account.bank_name = "Deutsche Bank"
      @bank_account.iban = "DE1234567890"

      assert @bank_account.save
      assert_equal "Billing::Recipient", @bank_account.holder_type
    end

    test "holder is accessible through polymorphic association" do
      issuer = billing_issuers(:one)
      @bank_account.holder = issuer
      @bank_account.name = "Test"
      @bank_account.bank_name = "Test Bank"
      @bank_account.iban = "DE0000000000"
      @bank_account.save!

      @bank_account.reload
      assert_equal issuer, @bank_account.holder
    end
  end
end