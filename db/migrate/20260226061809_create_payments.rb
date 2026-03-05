class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :status
      t.string :payment_method
      t.references :order, null: false, foreign_key: true
      t.string :transaction_id

      t.timestamps
    end
  end
end
