class CreateBrands < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.string :country
      t.boolean :active

      t.timestamps
    end
  end
end
