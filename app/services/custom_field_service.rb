# frozen_string_literal: true

class CustomFieldService
  FIELD_SIZE_LIMIT = {
    date: 10,
    number: 10,
    string: 10
  }.freeze
  VALID_FIELD_TYPES = %w[date number string].freeze

  def initialize(entity, custom_fields)
    @entity = entity
    @custom_fields = custom_fields
  end

  def process_custom_fields
    grouped_custom_fields = group_custom_fields_by_data_type

    grouped_custom_fields.each do |type, custom_fields|
      filtered_custom_fields = filtered_custom_fields(custom_fields, type)

      process_custom_fields_by_type(filtered_custom_fields, type)
    end
  end

  private

  def group_custom_fields_by_data_type
    custom_fields_by_type = {}
    VALID_FIELD_TYPES.each do |type|
      custom_fields_by_type[type] = @custom_fields.select { |field| field['data_type'] == type }
    end
    custom_fields_by_type
  end

  # Limit the number of records on each type
  # Should move the validation at model level
  def filtered_custom_fields(custom_fields, type)
    size_limit = FIELD_SIZE_LIMIT[type.to_sym]
    custom_fields.first(size_limit)
  end

  def process_custom_fields_by_type(custom_fields, data_type)
    existing_custom_fields_id = @entity.custom_fields.by_data_type(data_type).pluck(:id)
    new_custom_fields_id = []

    custom_fields.each do |custom_field|
      field = CustomField.find_or_initialize_by(customizable: @entity,
                                                field_name: custom_field[:field_name],
                                                data_type: data_type)
      field.value = custom_field[:value]
      field.save!
      new_custom_fields_id << field.id
    rescue StandardError => e
      Rails.logger.error("Could not process the custome field: #{custom_field}, error: #{e.message}")
    end

    cleanup_custom_fields(existing_custom_fields_id, new_custom_fields_id)
  end

  def cleanup_custom_fields(existing_custom_fields_id, new_custom_fields_id)
    ids_to_delete = existing_custom_fields_id - new_custom_fields_id

    CustomField.where(id: ids_to_delete).destroy_all
  end
end
