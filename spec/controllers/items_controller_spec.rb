require 'rails_helper'

describe ItemsController do

  let(:valid_attributes) { FactoryBot.attributes_for(:item) }
  let(:invalid_attributes) { valid_attributes.merge({ name: "" }) }

  let(:item)     { FactoryBot.create(:item, location: location) }
  let(:location) { FactoryBot.create(:location, user: user) }
  let(:user)     { FactoryBot.create(:user) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ItemsController. Be sure to keep this updated too.

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: item.to_param }
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
      get :edit, params: { id: item.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    before(:each) { sign_in user }

    context "with valid params" do
      it "creates a new Item" do
        expect {
          post :create, params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it "redirects to the created item" do
        post :create, params: { item: valid_attributes }
        expect(response).to redirect_to(Item.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { item: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    before(:each) { sign_in user }

    context "with valid params" do
      let(:new_attributes) { {
        name: "Chicken Rice",
        price: "$1.99",
        description: "Just like Singaporean chicken rice lah!"
      } }

      it "updates the requested item" do
        put :update, params: { id: item.to_param, item: new_attributes }
        item.reload
        expect(item.name).to eq(new_attributes[:name])
        expect(item.price.to_s).to eq("1.99")
        expect(item.description).to eq(new_attributes[:description])
      end

      it "redirects to the item" do
        put :update, params: { id: item.to_param, item: valid_attributes }
        expect(response).to redirect_to(item)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: item.to_param, item: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) { sign_in user }

    it "destroys the requested item" do
      item.touch

      expect {
        delete :destroy, params: { id: item.to_param }
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the location_path" do
      delete :destroy, params: { id: item.to_param }
      expect(response).to redirect_to(location_path(location))
    end
  end

end
