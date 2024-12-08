class ChangeNumberNotNullInBillingInvoices < ActiveRecord::Migration[7.1]
  def change
    change_column_null :billing_invoices, :number, false
  end
end