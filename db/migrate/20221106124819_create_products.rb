class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.string :external_id
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
