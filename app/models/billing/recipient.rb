module Billing
  class Recipient < ApplicationRecord
    has_many :invoices, foreign_key: "billing_recipient_id", dependent: :destroy

    validates :name, presence: true
  end
end
