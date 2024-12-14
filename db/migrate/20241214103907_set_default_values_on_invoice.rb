class SetDefaultValuesOnInvoice < ActiveRecord::Migration[7.1]
  def change
    change_column_default :billing_invoices, :net_total, from: nil, to: 0
    change_column_default :billing_invoices, :tax_rate, from: nil, to: 0
    change_column_default :billing_invoices, :tax_amount, from: nil, to: 0
    change_column_default :billing_invoices, :gross_total, from: nil, to: 0
  end
end
