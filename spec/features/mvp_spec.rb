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

    fill_in 'user[name]',  with: (new_name = "Carme Ruscalleda")
    fill_in 'user[email]', with: (new_email = "carme.ruscalleda@example.com")
    fill_in 'user[phone]', with: (new_phone = "+62 123 4567 8901")
    click_button 'Update'

    wait_until { page.current_path == root_path }
    user.reload

    expect(user.name).to  eq(new_name)
    expect(user.email).to eq(new_email)
    expect(user.phone).to eq(new_phone)
  end

  it "lets users sign in and post!" do
    click_link 'Post!'
    wait_until { page.current_path == new_location_path }

    execute_script <<-JS
      document.getElementById('location_latitude').value = '#{location_attributes.latitude}';
      document.getElementById('location_longitude').value = '#{location_attributes.longitude}';
    JS
    fill_in 'location[name]', with: location_attributes.name

    attach_file 'location[items_attributes][0][image]', Rails.root.join("spec", "fixtures", "spring-rolls.jpg")
    click_button 'Create'

    validation_message = page.find("#location_items_attributes_0_name").native.attribute("validationMessage")
    expect(validation_message ).to eq("Please fill out this field.")

    fill_in     'location[items_attributes][0][name]', with: item_attributes.name
    fill_in     'location[items_attributes][0][price]', with: item_attributes.price
    click_button 'Create'

    location = Location.last
    expect(location.latitude).to eq(location_attributes.latitude)
    expect(location.longitude).to eq(location_attributes.longitude)
    expect(location.name).to eq(location_attributes.name)

    item = Item.last
    expect(item.image).to be_attached
    expect(item.name).to  eq(item_attributes.name)
    expect(item.price).to eq(item_attributes.price)

    expect(location.items).to include(item)
  end

end

