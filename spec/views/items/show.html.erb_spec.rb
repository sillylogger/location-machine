require 'rails_helper'

describe "items/show" do
  before(:each) do
    @item = assign(:item, FactoryBot.create(:item))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to include(@item.name)
    expect(rendered).to include(@item.price.to_s)
    expect(rendered).to include(@item.description)
  end
end
