require 'rails_helper'

RSpec.describe CustomFieldsController, type: :controller do
  let(:entity) { FactoryBot.create(:product) }

  describe 'index' do
    let!(:custom_field_1) { FactoryBot.create(:custom_field, customizable: entity) }
    let!(:custom_field_2) { FactoryBot.create(:custom_field, customizable: entity) }

    it 'get all the cusotm fields for a given entity' do
      get(:index, params: { entity: 'product', entity_id: entity.id })

      expect(@response.code.to_i).to eq(200)
      custom_fields = JSON.parse(@response.body)['custom_fields']
      expect(custom_fields.map { |f| f['id'] }).to eq([custom_field_1.id, custom_field_2.id])
    end
  end

  describe 'create' do
    subject { post(:create, params: { entity: 'product', entity_id: entity.id, custom_fields: test_custom_fields }) }

    context 'when custom field count is within the threshold' do
      let(:test_custom_fields) do
        10.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      it 'add the custom fields' do
        subject

        expect(@response.code).to eq('200')
        expect(entity.reload.custom_fields.count).to eq(10)
      end
    end

    context 'when the custom fields count is greater than the threshold' do
      let(:test_custom_fields) do
        15.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      it 'limit the custom fields count' do
        subject

        expect(@response.code).to eq('200')
        expect(entity.reload.custom_fields.count).to eq(11)
      end
    end
  end

  describe 'update' do
    let!(:entity) { FactoryBot.create(:product) }
    let!(:test_custom_field) { FactoryBot.create(:custom_field, customizable: entity) }

    subject { patch(:update, params: { entity: 'product', entity_id: entity.id, custom_fields: test_custom_fields }) }

    context 'when custom field count is within the threshold' do
      let(:test_custom_fields) do
        10.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      it 'add the custom fields' do
        subject

        expect(@response.code).to eq('200')
        expect(entity.reload.custom_fields.count).to eq(10)
        expect { test_custom_field.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the custom fields count is greater than the threshold' do
      let(:test_custom_fields) do
        15.times.map { |i| { field_name: "field_name_#{i}", value: "value_#{i}", data_type: 'string' } }
      end

      it 'limit the custom fields count' do
        subject

        expect(@response.code).to eq('200')
        expect(entity.reload.custom_fields.count).to eq(11)
        expect { test_custom_field.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'destroy' do
    let!(:entity) { FactoryBot.create(:product, :custom_fields) }

    subject { delete(:destroy, params: { entity: 'product', entity_id: entity.id }) }

    it 'delete all the custom fields for the entity' do
      expect { subject }.to change { entity.custom_fields.count }.by(-2)
    end
  end
end
