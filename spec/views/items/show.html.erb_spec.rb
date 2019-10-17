require 'rails_helper'

describe "items/show" do

  let(:location)  { FactoryBot.create(:location) }
  let(:item)      { FactoryBot.create(:item, location: location ) }

  before(:each) do
    assign(:location, location)

    expect(item).to receive(:editor?).and_return true
    assign(:item, item)
    render
  end

  it "renders attributes in <p>" do
    expect(rendered).to include(item.name)
    expect(rendered).to include(item.description)
  end

  context "breadcrumbs" do
    it "shows breadcrumb with location name and item name" do
      expect(rendered).to have_content("#{location.name} > #{item.name}")
    end
  end
end
