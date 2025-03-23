module Billing
  class Issuer < ApplicationRecord
    has_many :invoices, foreign_key: "billing_issuer_id", dependent: :destroy

    validates :tax_number, :name, :address, :phone, :email, presence: true

    has_one :bank_account, as: :holder, dependent: :destroy
  end
end
