require 'rails_helper'

describe "the MVP flow" do

  let!(:user) { FactoryBot.create :user }

  let(:lat) {  -6.2189898 }
  let(:lng) { 106.7861758 }
  let(:name) { "Food from Home" }
  let(:description) { "Cooked with Love" }

  it "lets users sign in and edit their profile" do
    visit new_user_session_path

    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }

    click_link user.name
    wait_until { page.current_path == edit_user_registration_path }

    execute_script <<-JS
      document.getElementById('user_latitude').value = '#{lat}';
      document.getElementById('user_longitude').value = '#{lng}';
    JS

    fill_in 'user[name]',        with: name
    fill_in 'user[description]', with: description
    fill_in 'user[email]',       with: user.email
    fill_in 'user[phone]',       with: user.phone

    click_button 'Update'
    wait_until { page.current_path == root_path }

    user.reload
    expect(user.name).to eq(name)
    expect(user.email).to eq(user.email)
    expect(user.phone).to eq(user.phone)

    location = user.locations.first
    expect(location.latitude).to eq(lat)
    expect(location.longitude).to eq(lng)
    expect(location.name).to eq(name)
    expect(location.description).to eq(description)
  end

  it "lets users sign in, create a location, and see it" do
    visit new_user_session_path

    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }

    click_link 'Post your location!'
    wait_until { page.current_path == new_location_path }

    execute_script <<-JS
      document.getElementById('location_latitude').value = '#{lat}';
      document.getElementById('location_longitude').value = '#{lng}';
    JS
    fill_in 'location[name]',        with: name
    fill_in 'location[description]', with: 'Cooked with Love'
    click_button 'Create Location'
    wait_until { page.current_path == root_path }

    location = Location.last
    expect(location.name).to eq(name)
    expect(location.latitude).to eq(lat)
    expect(location.longitude).to eq(lng)
  end

end

