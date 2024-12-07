require "application_system_test_case"

module Billing
  class RecipientsTest < ApplicationSystemTestCase
    setup do
      @recipient = billing_recipients(:one)
    end

    test "visiting the index" do
      visit recipients_url
      assert_selector "h1", text: "Recipients"
    end

    test "should create recipient" do
      visit recipients_url
      click_on "New recipient"

      fill_in "Address", with: @recipient.address
      fill_in "Email", with: @recipient.email
      fill_in "Name", with: @recipient.name
      fill_in "Phone", with: @recipient.phone
      fill_in "Taxnumber", with: @recipient.taxNumber
      click_on "Create Recipient"

      assert_text "Recipient was successfully created"
      click_on "Back"
    end

    test "should update Recipient" do
      visit recipient_url(@recipient)
      click_on "Edit this recipient", match: :first

      fill_in "Address", with: @recipient.address
      fill_in "Email", with: @recipient.email
      fill_in "Name", with: @recipient.name
      fill_in "Phone", with: @recipient.phone
      fill_in "Taxnumber", with: @recipient.taxNumber
      click_on "Update Recipient"

      assert_text "Recipient was successfully updated"
      click_on "Back"
    end

    test "should destroy Recipient" do
      visit recipient_url(@recipient)
      click_on "Destroy this recipient", match: :first

      assert_text "Recipient was successfully destroyed"
    end
  end
end
