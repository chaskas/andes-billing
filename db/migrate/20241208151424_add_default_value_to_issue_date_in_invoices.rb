class AddDefaultValueToIssueDateInInvoices < ActiveRecord::Migration[7.1]
  def change
    change_column_default :billing_invoices, :issue_date, -> { 'CURRENT_TIMESTAMP' }
    change_column_null :billing_invoices, :issue_date, false
  end
end
