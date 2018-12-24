require 'rails_helper'

describe "locations/edit" do
  before(:each) do
    user = User.create(email: "foobar@example.com")

    @location = assign(:location, Location.create!(
      :user => user,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do
      assert_select "input[name=?]", "location[name]"
      assert_select "textarea[name=?]", "location[description]"
    end
  end
end
