require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user, first_name: 'test_user') }

  before do
    session[:user_id] = user.id
  end

  describe '#show' do
    context 'when the user is present' do
      it 'return the user details' do
        get(:show, params: { id: user.id })

        expect(@response.code).to eq('200')

        user = JSON.parse(@response.body)
        expect(user['first_name']).to eq('test_user')
      end
    end
  end

  describe '#create' do
    context 'when the input is not valid' do
      it 'raise an error' do
        post(:create, params: { first_name: 'test', last_name: 'test' })

        expect(@response.code).to eq('400')
      end
    end

    context 'when the input is valid' do
      it 'create the user' do
        post(:create, params: { first_name: 'test', last_name: 'test', email: 'email@test.com', password: 'test' })

        expect(@response.code).to eq('200')
        expect(User.last.email).to eq('email@test.com')
      end
    end
  end

  describe '#update' do
    context 'when the input is not valid' do
      it 'raise an error' do
        post(:update, params: { id: user.id, first_name: nil })

        expect(@response.code).to eq('400')
      end
    end

    context 'when the input is valid' do
      it 'update the user' do
        post(:update, params: { id: user.id, email: 'email1@test.com' })

        expect(@response.code).to eq('200')
        expect(User.last.email).to eq('email1@test.com')
      end
    end
  end
end
