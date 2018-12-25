require 'rails_helper'

describe "items/new" do
  before(:each) do
    assign(:item, FactoryBot.build(:item))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do
      assert_select "input[name=?]", "item[name]"
      assert_select "input[name=?]", "item[price]"
      assert_select "textarea[name=?]", "item[description]"
    end
  end
end
