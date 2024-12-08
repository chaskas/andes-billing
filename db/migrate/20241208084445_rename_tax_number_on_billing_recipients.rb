class RenameTaxNumberOnBillingRecipients < ActiveRecord::Migration[7.1]
  def change
    rename_column :billing_recipients, :taxNumber, :tax_number
  end
end
