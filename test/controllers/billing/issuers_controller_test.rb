require "test_helper"

module Billing
  class IssuersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @issuer = billing_issuers(:one)
    end

    test "should get index" do
      get issuers_url
      assert_response :success
    end

    test "should get new" do
      get new_issuer_url
      assert_response :success
    end

    test "should create issuer" do
      assert_difference("Issuer.count") do
        post issuers_url, params: { issuer: { address: @issuer.address, email: @issuer.email, name: @issuer.name, phone: @issuer.phone, tax_number: @issuer.tax_number } }
      end

      assert_redirected_to issuer_url(Issuer.last)
    end

    test "should show issuer" do
      get issuer_url(@issuer)
      assert_response :success
    end

    test "should get edit" do
      get edit_issuer_url(@issuer)
      assert_response :success
    end

    test "should update issuer" do
      patch issuer_url(@issuer), params: { issuer: { address: @issuer.address, email: @issuer.email, name: @issuer.name, phone: @issuer.phone, tax_number: @issuer.tax_number } }
      assert_redirected_to issuer_url(@issuer)
    end

    test "should destroy issuer" do
      assert_difference("Issuer.count", -1) do
        delete issuer_url(@issuer)
      end

      assert_redirected_to issuers_url
    end
  end
end
