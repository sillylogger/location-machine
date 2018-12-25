require 'rails_helper'

describe "items/edit" do

  before(:each) do
    @item = assign(:item, FactoryBot.create(:item))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do
      assert_select "input[name=?]", "item[name]"
      assert_select "input[name=?]", "item[price]"
      assert_select "textarea[name=?]", "item[description]"
    end
  end

end
