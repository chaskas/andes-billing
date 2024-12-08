class CreateBillingInvoices < ActiveRecord::Migration[7.1]
  def change

    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :billing_invoices, id: :uuid do |t|
      t.datetime :issue_date
      t.integer :status
      t.integer :number
      t.references :billing_issuer, null: false, foreign_key: true
      t.references :billing_recipient, null: false, foreign_key: true
      t.decimal :net_total
      t.integer :tax_rate
      t.decimal :tax_amount
      t.decimal :gross_total

      t.timestamps
    end
  end
end
