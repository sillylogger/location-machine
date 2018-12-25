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

    fill_in 'user[name]',        with: user.name
    fill_in 'user[email]',       with: user.email
    fill_in 'user[phone]',       with: user.phone
    click_button 'Update'

    user.reload
    wait_until { page.current_path == root_path }

    expect(user.name).to  eq(user.name)
    expect(user.email).to eq(user.email)
    expect(user.phone).to eq(user.phone)
  end

  it "lets users sign in and edit their location" do
    click_link user.name
    wait_until { page.current_path == edit_user_registration_path }

    click_link "Edit your Location"
    wait_until { page.current_path == edit_location_path(user.location) }

    execute_script <<-JS
      document.getElementById('location_latitude').value = '#{location_attributes.latitude}';
      document.getElementById('location_longitude').value = '#{location_attributes.longitude}';
    JS
    fill_in 'location[name]',        with: location_attributes.name
    fill_in 'location[description]', with: location_attributes.description
    click_button 'Update'

    location = user.location
    wait_until { page.current_path == root_path }

    expect(location.latitude).to     eq(location_attributes.latitude)
    expect(location.longitude).to    eq(location_attributes.longitude)
    expect(location.name).to         eq(location_attributes.name)
    expect(location.description).to  eq(location_attributes.description)
  end

  it "lets users (with a location) sign in and post an item" do
    click_link 'Post!'
    wait_until { page.current_path == new_item_path }

    attach_file 'item[image]',    Rails.root.join("spec", "fixtures", "spring-rolls.jpg")
    fill_in 'item[name]',         with: item_attributes.name
    fill_in 'item[price]',        with: item_attributes.price
    fill_in 'item[description]',  with: item_attributes.description
    click_button 'Create'

    item = Item.last
    wait_until { page.current_path == item_path(item) }

    expect(item.image).to         be_attached
    expect(item.name).to          eq(item_attributes.name)
    expect(item.price).to         eq(item_attributes.price)
    expect(item.description).to   eq(item_attributes.description)
  end

end

