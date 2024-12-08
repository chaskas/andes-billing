module Billing
  class Recipient < ApplicationRecord
    has_many :invoices
  end
end
