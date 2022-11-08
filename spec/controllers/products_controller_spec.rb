# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe '#index' do
    before do
      2.times { |_| FactoryBot.create(:product) }
    end

    it 'return all the products' do
      get(:index)

      expect(@response.code).to eq('200')
      products = JSON.parse(@response.body)['products']
      expect(products.count).to eq(2)
    end
  end

  describe '#show' do
    let(:product) { FactoryBot.create(:product, title: 'test_product') }

    context 'when the product is present' do
      it 'return the product details' do
        get(:show, params: { id: product.id })

        expect(@response.code).to eq('200')

        product = JSON.parse(@response.body)
        expect(product['title']).to eq('test_product')
      end
    end
  end

  describe '#create' do
    context 'when the input is valid' do
      it 'create the product' do
        post(:create, params: { title: 'test', description: 'test description', user_id: user.id })

        expect(@response.code).to eq('200')
        expect(Product.last.description).to eq('test description')
      end
    end

    context 'custom_fields' do
      let(:test_custom_fields) do
        10.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      context 'when custom field count is within the threshold' do
        it 'add the custom fields' do
          post(:create,
               params: { title: 'test', description: 'test description', user_id: user.id,
                         custom_fields: test_custom_fields })

          expect(@response.code).to eq('200')
          product = Product.last
          expect(product.custom_fields.count).to eq(10)
        end
      end

      context 'when the custom fields count is greater than the threshold' do
        let(:test_custom_fields) do
          15.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
        end

        it 'limit the custom fields count' do
          post(:create,
               params: { title: 'test', description: 'test description', user_id: user.id,
                         custom_fields: test_custom_fields })

          expect(@response.code).to eq('200')
          product = Product.last
          expect(product.custom_fields.count).to eq(11)
        end
      end
    end
  end

  describe '#update' do
    let(:product) { FactoryBot.create(:product, title: 'test_product') }

    context 'when the input is valid' do
      it 'update the product' do
        patch(:update, params: { id: product.id, description: 'test description1' })

        expect(@response.code).to eq('200')
        expect(Product.last.description).to eq('test description1')
      end
    end

    context 'custom_fields' do
      let(:test_custom_fields) do
        10.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      context 'when custom field count is within the threshold' do
        it 'add the custom fields' do
          patch(:update, params: { id: product.id, custom_fields: test_custom_fields })

          expect(@response.code).to eq('200')
          expect(product.custom_fields.count).to eq(10)
        end
      end
    end

    context 'when the custom fields count is greater than the threshold' do
      let(:test_custom_fields) do
        15.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      it 'limit the custom fields count' do
        post(:create,
             params: { title: 'test', description: 'test description', user_id: user.id,
                       custom_fields: test_custom_fields })

        expect(@response.code).to eq('200')
        product = Product.last
        expect(product.custom_fields.count).to eq(11)
      end
    end
  end
end
