require 'rails_helper'

describe 'Location Page' do
  let(:item) { FactoryBot.create(:item, :with_image) }
  let(:location) { item.location }

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

