module Billing
  class InvoiceItem < ApplicationRecord
    belongs_to :invoice, class_name: "Billing::Invoice", foreign_key: "billing_invoice_id"

    enum kind: [ :normal, :trial ]

    validates :date, presence: true
  end
end
