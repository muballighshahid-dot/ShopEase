class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
