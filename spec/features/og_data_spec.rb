require 'rails_helper'

describe 'OG data' do
  let(:item) { FactoryBot.create(:item, :with_image) }
  let(:location) { item.location }

  context 'location page' do
    it "contains og data for location page" do
      visit location_path(location.id)

      within("head", visible: false) do
        expect(page.all('meta[property="og:title"]', visible: false).first[:content]).to eq location.name
        expect(page.all('meta[property="og:type"]', visible: false).first[:content]).to eq 'website'
        expect(page.all('meta[property="og:url"]', visible: false).first[:content]).to be_present
        expect(page.all('meta[property="og:image"]', visible: false).first[:content]).to be_present
        expect(page.all('meta[property="og:description"]', visible: false).first[:content]).to eq location.description
      end
    end
  end

  context 'item page' do
    it "contains og data for item page" do
      visit location_item_path(location_id: location.id, id: item.id)

      within("head", visible: false) do
        expect(page.all('meta[property="og:title"]', visible: false).first[:content]).to eq item.name
        expect(page.all('meta[property="og:type"]', visible: false).first[:content]).to eq 'website'
        expect(page.all('meta[property="og:url"]', visible: false).first[:content]).to be_present
        expect(page.all('meta[property="og:image"]', visible: false).first[:content]).to be_present
        expect(page.all('meta[property="og:description"]', visible: false).first[:content]).to eq item.description
      end
    end
  end
end

