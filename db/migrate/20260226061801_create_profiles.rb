class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.string :address
      t.date :date_of_birth
      t.string :gender

      t.timestamps
    end
  end
end
