module Billing
  class Recipient < ApplicationRecord
    has_many :invoices

    validates :name, presence: true
  end
end
