require 'rails_helper'

describe ItemsController do

  let(:item)     { FactoryBot.create(:item, location: location) }
  let(:location) { FactoryBot.create(:location, user: user) }
  let(:user)     { FactoryBot.create(:user) }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { location_id: location.to_param,
                           id: item.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    before(:each) { sign_in user }

    it "returns a success response" do
      get :new, params: { location_id: location.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    before(:each) { sign_in user }

    it "returns a success response" do
      get :edit, params: { location_id: location.to_param,
                           id: item.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    before(:each) { sign_in user }

    context "with valid params" do
      let(:valid_params) { FactoryBot.attributes_for(:item) }

      it "creates a new Item" do
        expect {
          post :create, params: { location_id: location.to_param,
                                  item: valid_params }
        }.to change(Item, :count).by(1)
      end

      it "redirects to the created item" do
        expect {
          post :create, params: { location_id: location.to_param,
                                  item: valid_params }
        }.to change(Item, :count).by(1)
        expect(response).to redirect_to(location_path(location))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { FactoryBot.attributes_for(:item).merge(name: '') }

      it "returns a success response (i.e. to display the 'new' template)" do
        expect {
          post :create, params: { location_id: location.to_param,
                                  item: invalid_params }
        }.not_to change(Item, :count)
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    before(:each) { sign_in user }

    context "with valid params" do
      let(:valid_params) { FactoryBot.attributes_for(:item) }

      it "updates the requested item" do
        put :update, params: { location_id: location.to_param,
                               id: item.to_param,
                               item: valid_params.merge(price: '1.99') }
        item.reload
        expect(item.name).to        eq(valid_params[:name])
        expect(item.price.to_s).to  eq('1.99')
        expect(item.description).to eq(valid_params[:description])
      end

      it "redirects to the item" do
        put :update, params: { location_id: location.to_param,
                               id: item.to_param,
                               item: valid_params }
        expect(response).to redirect_to(location_path(location))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { FactoryBot.attributes_for(:item).merge(name: '') }

      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { location_id: location.to_param,
                               id: item.to_param,
                               item: invalid_params }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) { sign_in user }

    it "destroys the requested item" do
      item.touch

      expect {
        delete :destroy, params: { location_id: location.to_param,
                                   id: item.to_param }
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the location_path" do
      delete :destroy, params: { location_id: location.to_param,
                                 id: item.to_param }
      expect(response).to redirect_to(location)
    end
  end

end
