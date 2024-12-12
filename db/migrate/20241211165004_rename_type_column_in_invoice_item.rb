class RenameTypeColumnInInvoiceItem < ActiveRecord::Migration[7.1]
  def change
    rename_column :billing_invoice_items, :type, :kind
  end
end
