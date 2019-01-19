require 'rails_helper'

describe "items/new" do
  before(:each) do
    @location = assign(:item, FactoryBot.create(:location))
    @item = assign(:item, FactoryBot.build(:item))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", location_items_path(@location), "post" do
      assert_select "input[name=?]", "item[name]"
      assert_select "input[name=?]", "item[price]"
      assert_select "textarea[name=?]", "item[description]"
    end
  end
end
