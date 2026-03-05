class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.string :tracking_number
      t.string :carrier
      t.string :status
      t.references :order, null: false, foreign_key: true
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
