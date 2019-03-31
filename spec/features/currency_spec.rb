require 'rails_helper'

describe 'Currency Format' do
  let(:item) { FactoryBot.create(:item, price: 100) }
  let(:location) { item.location }

  include_examples 'admin login'

  it "let user/admin see currency format in item page/admin page" do
    item_path = location_item_path(location_id: location.id, id: item.id)
    visit item_path
    expect(page.current_path).to include(item_path)
    expect(page).to have_content "$100.00"

    visit admin_items_path
    expect(page.current_path).to include(admin_items_path)
    expect(page).to have_content "$100.00"

    item_path = location_item_path(location_id: location.id, id: item.id, locale: 'vi')
    visit item_path
    expect(page).to have_content item.name
    expect(page).to have_content "100,00 US$"
  end
end

