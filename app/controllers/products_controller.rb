# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :load_product, only: %i[show update destroy]

  def index
    render json: { products: Product.all }, status: :ok
  end

  def show
    render json: @product, status: :ok
  end

  def create
    # Should we handle both custom field and product creation in a single
    # transaction? ActiveRecord::Base.transaction {...}
    @product = Product.new(product_params)

    if @product.save
      process_custom_fields
      render json: { message: 'Product created successfully!' }, status: :ok
    else
      render json: { message: 'Could not create product!', error: @product.errors.full_messages }, status: :bad_request
    end
  end

  def update
    # Should we handle both custom field and product creation in a single
    # transaction? ActiveRecord::Base.transaction {...}

    if @product.update(product_params)
      process_custom_fields
      render json: { message: 'Product updated successfully!' }, status: :ok
    else
      render json: { message: 'Could not update product!', error: @product.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if @product.destroy
      render json: { message: 'Product deleted successfully!' }, status: :ok
    else
      render json: { message: 'Product creation failed!' }, status: :bad_request
    end
  end

  private

  def process_custom_fields
    custom_fields = custom_field_params[:custom_fields]
    return if custom_fields.blank?

    custom_field_service = CustomFieldService.new(@product, custom_fields)
    custom_field_service.process_custom_fields
  end

  def custom_field_params
    params.permit(custom_fields: %i[field_name value data_type])
  end

  def product_params
    params.permit(:title, :description, :external_id, :price, :user_id)
  end

  def load_product
    @product = Product.find_by(params[:id])
    render json: { message: 'Resource not found!' }, status: :not_found if @product.blank?
  end
end
