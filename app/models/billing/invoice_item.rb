module Billing
  class InvoiceItem < ApplicationRecord
    belongs_to :invoice, class_name: "Billing::Invoice", foreign_key: "billing_invoice_id"

    validates :date, :duration, :type, :unit_price, presence: true
  end
end
