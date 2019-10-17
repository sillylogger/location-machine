require 'rails_helper'

describe 'Click to chat' do
  let(:item) { FactoryBot.create(:item) }
  let(:location) { item.location }
  let(:seller) { location.user }

  let(:action_connect_text) { I18n.t('lm.action.connect', default: 'Click to Chat') }

  include_examples 'user login'

  context 'location page' do
    context 'seller has phone number' do
      it "allow user to click to chat with seller" do
        visit location_path(location.id)

        expect(page).to have_button(action_connect_text)
        click_button action_connect_text

        wait_until { page.current_path == user_chats_path(user_id: seller.id) }

        expect(page).to have_content "WhatsApp"
        expect(page).to have_content "Zalo"
        expect(page).to have_content seller.phone
      end
    end

    context 'seller does not have phone number' do
      before do
        seller.update(phone: nil)
      end

      it "hide click to chat" do
        visit location_path(location.id)

        expect(page).not_to have_button(action_connect_text)
      end
    end
  end

  context 'item page' do
    it "allow user to click to chat with seller in show item page" do
      visit location_item_path(location_id: location.id, id: item.id)

      expect(page).to have_button(action_connect_text)
      click_button action_connect_text

      wait_until { page.current_path == user_chats_path(user_id: seller.id) }

      expect(page).to have_content "WhatsApp"
      expect(page).to have_content "Zalo"
      expect(page).to have_content seller.phone
    end
  end
end

