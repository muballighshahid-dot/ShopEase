class CreateCoupons < ActiveRecord::Migration[8.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :discount_type
      t.decimal :discount_value
      t.date :expiry_date
      t.boolean :active

      t.timestamps
    end
  end
end
