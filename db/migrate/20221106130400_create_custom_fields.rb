class CreateCustomFields < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_fields do |t|
      t.string :field_name
      t.string :value
      t.references :customizable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
