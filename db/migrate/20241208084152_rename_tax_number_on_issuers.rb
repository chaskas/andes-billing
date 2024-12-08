class RenameTaxNumberOnIssuers < ActiveRecord::Migration[7.1]
  def change
    rename_column :billing_issuers, :taxNumber, :tax_number
  end
end
