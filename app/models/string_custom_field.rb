# == Schema Information
#
# Table name: custom_fields
#
#  id                :bigint           not null, primary key
#  customizable_type :string(255)      not null
#  field_name        :string(255)
#  type              :string(255)      not null
#  value             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customizable_id   :bigint           not null
#
# Indexes
#
#  index_custom_fields_on_customizable_type_and_customizable_id  (customizable_type,customizable_id)
#
class StringCustomField < CustomField

end
