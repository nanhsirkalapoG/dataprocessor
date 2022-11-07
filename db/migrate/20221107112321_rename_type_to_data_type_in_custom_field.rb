class RenameTypeToDataTypeInCustomField < ActiveRecord::Migration[5.2]
  def change
    rename_column :custom_fields, :type, :data_type
  end
end
