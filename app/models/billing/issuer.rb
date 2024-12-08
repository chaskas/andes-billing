module Billing
  class Issuer < ApplicationRecord
    has_many :invoices
  end
end
