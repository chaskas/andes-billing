class CreateBankAccount < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_bank_accounts do |t|

      t.string :name
      t.string :bank_name
      t.string :iban
      t.string :bic
      t.references :holder, polymorphic: true, null: true, index: true

      t.timestamps
    end
  end
end
