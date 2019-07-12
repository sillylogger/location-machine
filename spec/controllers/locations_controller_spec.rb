require 'rails_helper'

describe LocationsController do
  let(:user) { FactoryBot.create :user }

  let!(:location_1) { FactoryBot.create(:location, name: 'House of Cake') }
  let!(:location_2) { FactoryBot.create(:location, name: 'House of Pizza') }
  let!(:location_3) { FactoryBot.create(:location, name: 'House of Monkey') }
  let(:latitude) { 10 }
  let(:longitude) { 100 }

  before do
    Location.update(latitude: latitude, longitude: longitude)
    location_3.update(latitude: 0, longitude: 0)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end

    context 'json format' do
      context 'no bound' do
        it 'returns newest locations' do
          get :index, format: :json
          expect(response.body).to include location_1.name
          expect(response.body).to include location_2.name
          expect(response.body).to include location_3.name
        end
      end

      context 'has bound' do
        it 'returns newest locations within bounds' do
          get :index, params: { bounds: { south_west: [9, 99], north_east: [11, 101] } }, format: :json
          expect(response.body).to include location_1.name
          expect(response.body).to include location_2.name
          expect(response.body).not_to include location_3.name
        end
      end
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
          post :create, params: { location: FactoryBot.attributes_for(:location) }
        }.to change(Location, :count).by(1)
      end

      it "redirects to the created location" do
        post :create, params: { location: FactoryBot.attributes_for(:location) }
        expect(response).to redirect_to(location_path(Location.last))
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
        put :update, params: { id: location.to_param, location: new_attributes }

        location.reload
        expect(response).to redirect_to(location_path(location))
      end

      it "accepts nested attributes for items so they are not duplicated" do
        location = FactoryBot.create :location, user: user
        item = FactoryBot.create :item, location: location

        expect {
          put :update, params: { id: location.to_param, location: new_attributes.merge({
              items_attributes: [ item.attributes.slice(*%w(id name)) ]
            })
          }
        }.to change(Item, :count).by(0)

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
