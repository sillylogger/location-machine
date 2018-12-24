require 'rails_helper'

describe "Locations" do

  let(:user) { FactoryBot.create :user }

  before(:each) { sign_in user }

  describe "GET /locations/new" do
    it "works! (now write some real specs)" do
      get new_location_path
      expect(response).to have_http_status(200)
    end
  end

end
