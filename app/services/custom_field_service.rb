# frozen_string_literal: true

class CustomFieldService
  attr_reader :entity, :custom_fields

  def initialize(entity, custom_fields)
    @entity = entity
    @custom_fields = custom_fields
  end

  def process_custom_fields
    grouped_custom_fields = group_custom_fields_by_data_type

    grouped_custom_fields.each do |type, custom_fields_by_type|
      process_custom_fields_by_type(custom_fields_by_type, type)
    end
  end

  private

  def group_custom_fields_by_data_type
    custom_fields_by_type = {}
    CustomField::VALID_CUSTOM_FIELD_TYPES.each do |type|
      custom_fields_by_type[type] = custom_fields.select { |field| field['data_type'] == type }
    end
    custom_fields_by_type
  end

  def process_custom_fields_by_type(custom_fields, data_type)
    cleanup_custom_fields(custom_fields, data_type)

    custom_fields.each do |custom_field|
      field = CustomField.find_or_initialize_by(customizable: entity,
                                                field_name: custom_field[:field_name],
                                                data_type: data_type)
      field.value = custom_field[:value]
      break unless field.valid?

      entity.custom_fields << field
    end
  end

  def cleanup_custom_fields(custom_fields, data_type)
    custom_field_names = custom_fields.map { |field| field[:field_name] }

    entity.custom_fields.by_data_type(data_type).where.not(field_name: custom_field_names).destroy_all
  end
end
