module Billing
  class Issuer < ApplicationRecord
    has_many :invoices, foreign_key: "billing_issuer_id", dependent: :destroy
  end
end
