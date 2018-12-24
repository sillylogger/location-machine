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
    context "with valid params" do
      let(:location_attributes) { FactoryBot.attributes_for(:location) }

      it "updates the user and their location" do
        # expect(user.locations).to be_empty
        put :update, params: { id: user.to_param,
                               user: { }.merge(location_attributes) }
        user.reload
        expect(user.name).to eq(location_attributes[:name])
        expect(user.locations).to be_present

        location = user.locations.first
        expect(location.name).to eq(location_attributes[:name])
        expect(location.description).to eq(location_attributes[:description])
        expect(location.longitude).to eq(location_attributes[:longitude])
        expect(location.latitude).to eq(location_attributes[:latitude])
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
      end
    end
  end

  # describe "DELETE #destroy" do
  #   it "destroys the requested location" do
  #     location = FactoryBot.create :location, user: user
  #     expect {
  #       delete :destroy, params: { id: location.to_param }
  #     }.to change(Location, :count).by(-1)
  #   end
  #
  #   it "redirects to the locations list" do
  #     location = FactoryBot.create :location, user: user
  #     delete :destroy, params: { id: location.to_param }
  #     expect(response).to redirect_to(root_path)
  #   end
  # end

end
