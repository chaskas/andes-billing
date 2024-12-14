module Billing
  class InvoiceItem < ApplicationRecord
    belongs_to :invoice, class_name: "Billing::Invoice", foreign_key: "billing_invoice_id"

    enum kind: [ :normal, :trial ]

    validates :date, presence: true

    after_save :update_invoice_totals
    after_destroy :update_invoice_totals

    private
      def update_invoice_totals
        self.invoice.set_net_total
        self.invoice.set_tax_amount
        self.invoice.set_gross_total
        self.invoice.save
      end
  end
end
