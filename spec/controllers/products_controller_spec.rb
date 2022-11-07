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
  end

  describe '#update' do
    let(:product) { FactoryBot.create(:product, title: 'test_product') }

    context 'when the input is valid' do
      it 'update the product' do
        post(:update, params: { id: product.id, description: 'test description1' })

        expect(@response.code).to eq('200')
        expect(Product.last.description).to eq('test description1')
      end
    end
  end
end
