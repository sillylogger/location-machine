require 'rails_helper'

describe "locations/show" do

  let(:user)      { FactoryBot.create(:user) }
  let(:location)  { FactoryBot.create(:location, user: user) }
  let!(:item)     { FactoryBot.create(:item, location: location) }

  before(:each) do
    assign(:location, location)
  end

  it "renders the location" do
    allow(view).to receive(:current_user).and_return nil
    render
    assert_select "a[href='#{edit_location_path(location)}']", false
  end

  it "shows edit links, when the location.user is the viewer" do
    allow(view).to receive(:current_user).and_return user
    render
    assert_select "a[href='#{edit_location_path(location)}']", true
  end

end
