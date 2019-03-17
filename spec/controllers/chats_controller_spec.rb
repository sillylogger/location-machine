require 'rails_helper'

describe ChatsController do
  describe "GET #index" do
    before(:each) { sign_in user }
    let(:user) { FactoryBot.create(:user) }

    context 'user is found' do
      it 'returns a success response' do
        get :index, params: { user_id: user.id }

        expect(response).to be_successful
      end
    end

    context 'user not found' do
      it 'returns not found' do
        expect {
          get :index, params: { user_id: 'invalid-id' }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
