class AddUniqueIndexToInvoicesNumberAndYear < ActiveRecord::Migration[7.1]
  def change
    add_column :billing_invoices, :year, :integer
    add_index :billing_invoices, [:number, :year], unique: true
  end
end
