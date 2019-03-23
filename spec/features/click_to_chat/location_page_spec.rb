require 'rails_helper'

describe 'Location Page' do
  let(:location) { FactoryBot.create(:location) }
  let(:seller) { location.user }

  include_examples 'user login'

  context 'seller has phone number' do
    it "allow user to click to chat with seller" do
      visit location_path(location.id)

      expect(page).to have_content("Click to Chat")

      click_link "Click to Chat"

      wait_until { page.current_path == user_chats_path(user_id: seller.id) }

      expect(page).to have_content "WhatsApp"
      expect(page).to have_content "Zalo"
    end
  end

  context 'seller does not have phone number' do
    before do
      seller.update(phone: nil)
    end

    it "hide click to chat" do
      visit location_path(location.id)

      expect(page).not_to have_content("Click to Chat")
    end
  end
end

