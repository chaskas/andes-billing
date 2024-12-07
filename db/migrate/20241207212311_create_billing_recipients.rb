class CreateBillingRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_recipients do |t|
      t.string :name
      t.string :taxNumber
      t.string :email
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
