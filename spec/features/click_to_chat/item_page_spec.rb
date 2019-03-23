require 'rails_helper'

describe 'Item Page' do
  let(:item) { FactoryBot.create(:item) }
  let(:location) { item.location }
  let(:seller) { location.user }

  include_examples 'user login'

  it "allow user to click to chat with seller in show item page" do
    visit location_item_path(location_id: location.id, id: item.id)

    expect(page).to have_content("Click to Chat")

    click_link "Click to Chat"

    wait_until { page.current_path == user_chats_path(user_id: seller.id) }

    expect(page).to have_content "WhatsApp"
    expect(page).to have_content "Zalo"
  end
end

