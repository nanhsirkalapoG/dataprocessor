class ProductsController < ApplicationController
  before_action :load_product, only: %i[show update destroy]

  def index
    render json: { products: Product.all }, status: :ok
  end

  def show
    render json: @product, status: :ok
  end

  def create
    process_custom_fields
    product = Product.new(product_params)

    if product.save
      render json: { message: 'Product created successfully!' }, status: :ok
    else
      render json: { message: 'Product creation failed!' }, status: :bad_request
    end
  end

  def update
    process_custom_fields

    if @product.update(product_params)
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

    custom_field_service = CustomFieldService.new(@product)
    custom_field_service.process_custom_fields(custom_fields)
  end

  def custom_field_params
    params.permit(custom_fields: [:field_name, :value, :type])
  end

  def product_params
    params.permit(:title, :description, :external_id, :price, :user_id)
  end

  def load_product
    @product = Product.find_by(params[:id])
    if @product.blank?
      render json: { message: 'Resource not found!' }, status: :not_found
    end
  end
end
