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
    after_save :update_tax_amount_if_tax_rate_changed
    before_create :assign_invoice_number

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

    def self.get_last_number_for_year(year)
      last_invoice = Invoice.where("extract(year from issue_date) = ?", year).order(:number).last
      if last_invoice
        last_invoice.number
      else
        0
      end
    end

    private
      def update_tax_amount_if_tax_rate_changed
        if saved_change_to_tax_rate?
          self.set_tax_amount
          self.gross_total = self.net_total + self.tax_amount.to_d
          self.save
        end
      end

      def assign_invoice_number
        year = self.issue_date.year
        last_number = Billing::Invoice.get_last_number_for_year(year)
        self.number = last_number.to_i + 1
      end
  end
end
