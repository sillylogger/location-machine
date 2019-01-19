require 'rails_helper'

describe "items/show" do
  
  let(:location)  { FactoryBot.create(:location) }
  let(:item)      { FactoryBot.create(:item, location: location ) }

  before(:each) do
    assign(:location, location)

    expect(item).to receive(:editor?).and_return true
    assign(:item, item)
  end

  it "renders attributes in <p>" do
    render

    expect(rendered).to include(item.name)
    expect(rendered).to include(number_to_currency(item.price))
    expect(rendered).to include(item.description)
  end
end
