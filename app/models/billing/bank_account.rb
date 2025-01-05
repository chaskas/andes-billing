module Billing
  class BankAccount < ApplicationRecord
    belongs_to :holder, polymorphic: true, optional: false

    validates :name, :bank_name, :iban, presence: true
  end
end
