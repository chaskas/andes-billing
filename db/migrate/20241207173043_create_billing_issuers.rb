class CreateBillingIssuers < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_issuers do |t|
      t.string :name
      t.string :taxNumber
      t.string :email
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
