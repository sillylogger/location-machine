require 'rails_helper'

describe 'Item Page' do
  let(:item) { FactoryBot.create(:item) }
  let(:location) { item.location }
  let(:seller) { location.user }
  let(:buyer) { FactoryBot.create(:user) }

  before :each do
    visit new_user_session_path
    fill_in 'user[email]',    with: buyer.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }
  end

  it "allow buyer to click to chat with seller in show item page" do
    visit location_item_path(location_id: location.id, id: item.id)

    expect(page).to have_content("Click to chat")

    click_link "Click to chat"

    wait_until { page.current_path == user_chats_path(user_id: seller.id) }

    expect(page).to have_content "Whatsapp"
    expect(page).to have_content "Zalo"
  end
end

