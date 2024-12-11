class RemoveAmountColumnFromInvoiceItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :billing_invoice_items, :amount, type: :integer
  end
end
