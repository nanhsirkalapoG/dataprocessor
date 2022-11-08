# frozen_string_literal: true

class CustomFieldsController < ApplicationController
  ENTITY_MAP = {
    'product' => Product
  }.freeze
  before_action :load_entity

  def index
    render json: { custom_fields: @entity.custom_fields }, status: :ok
  end

  def create
    custom_fields_params = permitted_params[:custom_fields]
    custom_fields_params.each do |custom_field_params|
      @entity.custom_fields << CustomField.new(custom_field_params)
    end

    render json: { message: 'Custom fields are created successfully!' }, status: :ok
  end

  def update
    custom_fields_params = permitted_params[:custom_fields]
    custom_fields_params.each do |custom_field_params|
      custom_field = CustomField.find_or_initialize_by(
        customizable: @entity,
        field_name: custom_field_params[:field_name],
        data_type: custom_field_params[:data_type]
      )
      custom_field.value = custom_field_params[:value]
      @entity.custom_fields << custom_field
    end

    render json: { message: 'Custom fields are updated successfully!' }, status: :ok
  end

  def destroy
    @entity.custom_fields.destroy_all

    render json: { message: 'Custom fields are deleted successfully!' }, status: :ok
  end

  private

  def permitted_params
    params.permit(custom_fields: %i[field_name value data_type])
  end

  def load_entity
    entity = ENTITY_MAP[params[:entity]]
    @entity = entity.find_by_id(params[:entity_id])

    render json: { message: 'Entity not found!' }, status: :bad_request and return if @entity.blank?
  end
end
