require 'rails_helper'

describe "the MVP flow" do

  let!(:user) { FactoryBot.create :user }
  let(:location_attributes) { FactoryBot.build :location }
  let(:item_attributes) { FactoryBot.build :item }

  before :each do
    visit new_user_session_path
    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }
  end

  it "lets users sign in and edit their profile" do
    click_link user.name
    wait_until { page.current_path == edit_user_registration_path }

    execute_script <<-JS
      document.getElementById('user_latitude').value = '#{location_attributes.latitude}';
      document.getElementById('user_longitude').value = '#{location_attributes.longitude}';
    JS

    fill_in 'user[name]',        with: location_attributes.name
    fill_in 'user[description]', with: location_attributes.description
    fill_in 'user[email]',       with: user.email
    fill_in 'user[phone]',       with: user.phone

    click_button 'Update'
    wait_until { page.current_path == root_path }

    user.reload
    expect(user.name).to  eq(user.name)
    expect(user.email).to eq(user.email)
    expect(user.phone).to eq(user.phone)

    location = user.location
    expect(location.latitude).to     eq(location_attributes.latitude)
    expect(location.longitude).to    eq(location_attributes.longitude)
    expect(location.name).to         eq(location_attributes.name)
    expect(location.description).to  eq(location_attributes.description)
  end

  it "lets users (with a location) sign in and post an item" do
    click_link 'Post!'
    wait_until { page.current_path == new_item_path }

    fill_in 'item[name]',        with: item_attributes.name
    fill_in 'item[price]',       with: item_attributes.price
    fill_in 'item[description]', with: item_attributes.description
    click_button 'Create'

    item = Item.last
    wait_until { page.current_path == item_path(item) }

    expect(item.name).to          eq(item_attributes.name)
    expect(item.price).to         eq(item_attributes.price)
    expect(item.description).to   eq(item_attributes.description)
  end

end

