require 'rails_helper'

describe LocationsController do

  let(:valid_attributes) { FactoryBot.attributes_for(:location) }
  let(:user) { FactoryBot.create :user }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    let(:location) { FactoryBot.create :location }

    it "returns a success response" do
      get :show, params: { id: location.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    before(:each) { sign_in user }

    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    before(:each) { sign_in user }

    it "returns a success response" do
      location = FactoryBot.create :location, user: user
      get :edit, params: { id: location.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    before(:each) { sign_in user }

    context "with valid params" do
      it "creates a new Location" do
        expect {
          post :create, params: { location: valid_attributes }
        }.to change(Location, :count).by(1)
      end

      it "redirects to the created location" do
        post :create, params: { location: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT #update" do
    before(:each) { sign_in user }

    context "with valid params" do
      let(:new_attributes) { {
        name: "Sweet Beef"
      } }

      it "updates the requested location" do
        location = FactoryBot.create :location, user: user
        put :update, params: { id: location.to_param, location: new_attributes }
        location.reload
        expect(location.name).to eq(new_attributes[:name])
      end

      it "redirects to the location" do
        location = FactoryBot.create :location, user: user
        put :update, params: { id: location.to_param, location: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) { sign_in user }

    it "destroys the requested location" do
      location = FactoryBot.create :location, user: user
      expect {
        delete :destroy, params: { id: location.to_param }
      }.to change(Location, :count).by(-1)
    end

    it "redirects to the locations list" do
      location = FactoryBot.create :location, user: user
      delete :destroy, params: { id: location.to_param }
      expect(response).to redirect_to(root_path)
    end
  end

end
