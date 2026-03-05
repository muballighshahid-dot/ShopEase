class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.decimal :total_amount
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
