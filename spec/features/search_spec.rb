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
  end

  it "search, see results, go to result, go back" do
    visit root_path

    page.find('a[name="search"]').click
    wait_until { page.current_path == search_path }
    expect(page).to have_content I18n.t('lm.search.items_title', default: 'Items')
    expect(page).to have_content item_1.name
    expect(page).to have_content item_2.name
    expect(page).to have_content item_3.name
    expect(page).not_to have_content item_4.name

    fill_in 'text', with: 'cake'
    find('.search-bar>input').native.send_keys(:return)
    wait_until { page.current_path == search_path }
    expect(page).to have_content I18n.t('lm.search.items_title', default: 'Items')
    expect(page).to have_content I18n.t('lm.search.locations_title', default: 'Locations')
    expect(page).to have_content item_1.name
    expect(page).to have_content item_2.name
    expect(page).not_to have_content item_4.name
    expect(page).to have_content location_1.name

    fill_in 'text', with: 'house'
    find('.search-bar>input').native.send_keys(:return)
    wait_until { page.current_path == search_path }
    expect(page).to have_content I18n.t('lm.search.locations_title', default: 'Locations')
    expect(page).to have_content location_1.name
    expect(page).not_to have_content location_2.name

    visit new_location_path
    page.find('a[name="search"]').click
    wait_until { page.current_path == search_path }
    page.find(".search-bar__back-icon").click
    wait_until { page.current_path == new_location_path }
  end
end
