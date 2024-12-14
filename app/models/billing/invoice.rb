module Billing
  class Invoice < ApplicationRecord
    belongs_to :issuer, class_name: "Billing::Issuer", foreign_key: "billing_issuer_id"
    belongs_to :recipient, class_name: "Billing::Recipient", foreign_key: "billing_recipient_id"

    has_many :invoice_items, class_name: "Billing::InvoiceItem", foreign_key: "billing_invoice_id", dependent: :destroy

    validates :issue_date, :billing_issuer_id, :billing_recipient_id, presence: true

    enum tax_rate: {
      exempt: 0,
      standard: 19,
      reduced: 7
    }

    before_save :set_gross_total

    def set_net_total
      self.net_total = self.invoice_items.sum(:unit_price) || 0
    end

    def set_tax_amount
      self.set_net_total
      self.tax_amount = self.net_total * self.tax_rate_before_type_cast.to_d / 100
    end

    def set_gross_total
      self.set_net_total
      self.set_tax_amount
      self.gross_total = self.net_total + self.tax_amount.to_d
    end

    private

      def get_last_number_for_year(year)
        last_invoice = Invoice.where("extract(year from issue_date) = ?", year).order(:number).last
        if last_invoice
          last_invoice.number
        else
          0
        end
      end

      def set_number
        self.number = get_last_number_for_year(self.issue_date.year) + 1
      end
  end
end
