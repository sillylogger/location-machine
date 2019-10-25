require "rails_helper"

describe "Search" do
  include_examples "user login"

  let!(:item_1) { FactoryBot.create(:item, name: 'cake of Ba Ngoai') }
  let!(:item_2) { FactoryBot.create(:item, name: 'noodles', description: 'noodles and cake of 4P') }
  let!(:item_3) { FactoryBot.create(:item, name: 'pizza 4P') }
  let!(:item_4) { FactoryBot.create(:item, name: 'cake of Ba Noi') }
  let!(:location_1) { FactoryBot.create(:location, name: 'House of Cake') }
  let!(:location_2) { FactoryBot.create(:location, name: 'House of Pizza') }
  let(:latitude) { -6.2189898 }
  let(:longitude) {106.7861758 }

  before do
    Location.update(latitude: latitude, longitude: longitude)
    item_4.location.update(latitude: 0, longitude: 0)
    location_2.update(latitude: 0, longitude: 0)
    [Item, Location].each do |klass|
      klass.find_each { |record| record.update_pg_search_document }
    end
  end

  it "show search results" do
    visit root_path

    fill_in 'query', with: 'cake'
    find('[name="query"]').native.send_keys :return
    expect(page).to have_content item_1.name
    expect(page).to have_content item_2.name
    expect(page).not_to have_content item_3.name
    expect(page).not_to have_content item_4.name

    fill_in 'query', with: 'house'
    find('[name="query"]').native.send_keys :return
    expect(page).to have_content location_1.name
    expect(page).not_to have_content location_2.name
  end
end
