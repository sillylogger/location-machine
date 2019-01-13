require 'rails_helper'

describe "locations/new" do
  before(:each) do
    assign(:location, Location.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new location form" do
    render

    assert_select "form[action=?][method=?]", locations_path, "post" do
      assert_select "input[name=?]", "location[name]"
    end
  end
end
