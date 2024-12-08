module Billing
  class Invoice < ApplicationRecord
    belongs_to :issuer, class_name: "Billing::Issuer", foreign_key: "billing_issuer_id"
    belongs_to :recipient, class_name: "Billing::Recipient", foreign_key: "billing_recipient_id"

    validates :issue_date, :billing_issuer_id, :billing_recipient_id, presence: true

    before_save :set_number

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
