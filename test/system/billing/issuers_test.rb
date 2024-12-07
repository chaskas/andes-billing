require "application_system_test_case"

module Billing
  class IssuersTest < ApplicationSystemTestCase
    setup do
      @issuer = billing_issuers(:one)
    end

    test "visiting the index" do
      visit issuers_url
      assert_selector "h1", text: "Issuers"
    end

    test "should create issuer" do
      visit issuers_url
      click_on "New issuer"

      fill_in "Address", with: @issuer.address
      fill_in "Email", with: @issuer.email
      fill_in "Name", with: @issuer.name
      fill_in "Phone", with: @issuer.phone
      fill_in "Taxnumber", with: @issuer.taxNumber
      click_on "Create Issuer"

      assert_text "Issuer was successfully created"
      click_on "Back"
    end

    test "should update Issuer" do
      visit issuer_url(@issuer)
      click_on "Edit this issuer", match: :first

      fill_in "Address", with: @issuer.address
      fill_in "Email", with: @issuer.email
      fill_in "Name", with: @issuer.name
      fill_in "Phone", with: @issuer.phone
      fill_in "Taxnumber", with: @issuer.taxNumber
      click_on "Update Issuer"

      assert_text "Issuer was successfully updated"
      click_on "Back"
    end

    test "should destroy Issuer" do
      visit issuer_url(@issuer)
      click_on "Destroy this issuer", match: :first

      assert_text "Issuer was successfully destroyed"
    end
  end
end
