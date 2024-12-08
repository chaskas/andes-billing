class CreateBillingInvoiceItems < ActiveRecord::Migration[7.1]
  def change

    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :billing_invoice_items, id: :uuid do |t|
      t.references :billing_invoice, type: :uuid, null: false, foreign_key: true
      t.datetime :date
      t.integer :duration
      t.integer :type
      t.integer :amount
      t.decimal :unit_price

      t.timestamps
    end
  end
end
