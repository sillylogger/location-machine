require 'rails_helper'

describe 'Click to chat' do
  let(:item) { FactoryBot.create(:item) }
  let(:location) { item.location }
  let(:seller) { location.user }

  include_examples 'user login'

  context 'location page' do
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

  context 'item page' do
    it "allow user to click to chat with seller in show item page" do
      visit location_item_path(location_id: location.id, id: item.id)

      expect(page).to have_content("Click to Chat")

      click_link "Click to Chat"

      wait_until { page.current_path == user_chats_path(user_id: seller.id) }

      expect(page).to have_content "WhatsApp"
      expect(page).to have_content "Zalo"
    end
  end
end

