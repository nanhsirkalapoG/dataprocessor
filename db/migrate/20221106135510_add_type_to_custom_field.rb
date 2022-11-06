class AddTypeToCustomField < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_fields, :type, :string, :null => false
  end
end
