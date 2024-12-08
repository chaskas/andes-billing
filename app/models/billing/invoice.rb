module Billing
  class Invoice < ApplicationRecord
    belongs_to :issuer, class_name: "Billing::Issuer", foreign_key: "billing_issuer_id"
    belongs_to :recipient, class_name: "Billing::Recipient", foreign_key: "billing_recipient_id"

    validates :issue_date, :billing_issuer_id, :billing_recipient_id, presence: true
  end
end
