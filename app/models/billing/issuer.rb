module Billing
  class Issuer < ApplicationRecord
    has_many :invoices, foreign_key: "billing_issuer_id", dependent: :destroy

    has_one :bank_account, as: :holder, dependent: :destroy
  end
end
