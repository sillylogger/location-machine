require 'rails_helper'

describe 'Location Page' do
  let(:location) { FactoryBot.create(:location) }
  let(:seller) { location.user }
  let(:buyer) { FactoryBot.create(:user) }

  before :each do
    visit new_user_session_path
    fill_in 'user[email]',    with: buyer.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }
  end

  context 'seller has phone number' do
    it "allow buyer to click to chat with seller" do
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

