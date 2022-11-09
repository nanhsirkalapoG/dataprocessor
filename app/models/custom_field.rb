# == Schema Information
#
# Table name: custom_fields
#
#  id                :bigint           not null, primary key
#  customizable_type :string(255)      not null
#  data_type         :string(255)      not null
#  field_name        :string(255)
#  value             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customizable_id   :bigint           not null
#
# Indexes
#
#  index_custom_fields_on_customizable_type_and_customizable_id  (customizable_type,customizable_id)
#
class CustomField < ApplicationRecord
  belongs_to :customizable, polymorphic: true

  validates_associated :customizable

  VALID_CUSTOM_FIELD_TYPES = %w[date number string]

  validates :data_type, inclusion: { in: VALID_CUSTOM_FIELD_TYPES }
  validates :field_name, uniqueness: { scope: [:customizable_type, :customizable_id] }

  scope :by_data_type, -> (data_type) { where(data_type: data_type) }
end
