class AddDescriptionToBillingInvoiceItems < ActiveRecord::Migration[7.1]
  def change
    add_column :billing_invoice_items, :description, :text
  end
end
