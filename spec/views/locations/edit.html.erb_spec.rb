require 'rails_helper'

describe "locations/edit" do

  let(:location) { FactoryBot.create(:location) }

  before(:each) do
    assign(:location, location)
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(location), "post" do
      assert_select "input[name=?]", "location[name]"
      assert_select "textarea[name=?]", "location[description]"
    end
  end

end
