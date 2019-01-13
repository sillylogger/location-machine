require 'rails_helper'

describe Users::RegistrationsController do

  let(:user) { FactoryBot.create :user }

  before(:each) {
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  }

  describe "GET #edit" do
    it "returns a success response" do
      get :edit
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    let(:name) { "Yogi Bear" }
    let(:email) { "yogi.bear@example.com" }
    let(:phone) { "+1 234 567 8901" }

    it "updates the user without a password" do
      put :update, params: { id: user.to_param,
                             user: { name: name, email: email, phone: phone  } }
      user.reload
      expect(user.name).to eq(name)
      expect(user.email).to eq(email)
      expect(user.phone).to eq(phone)
    end
  end

end
