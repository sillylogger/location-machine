require 'rails_helper'

describe "the MVP flow" do
  let(:location_attributes) { FactoryBot.build :location }
  let(:item_attributes) { FactoryBot.build :item }

  include_examples 'user login'

  it "lets users sign in and edit their profile" do
    visit root_path

    click_link user.name
    wait_until { page.current_path == edit_user_registration_path }

    fill_in 'user[name]',  with: (new_name = "Carme Ruscalleda")
    fill_in 'user[email]', with: (new_email = "carme.ruscalleda@example.com")
    fill_in 'user[phone]', with: (new_phone = "+62 123 4567 8901")
    click_button 'Save'

    wait_until { page.current_path == root_path }
    user.reload

    expect(user.name).to  eq(new_name)
    expect(user.email).to eq(new_email)
    expect(user.phone).to eq(new_phone)
  end

  it "lets users sign in and post" do
    visit root_path

    click_link 'Post'
    wait_until { page.current_path == new_location_path }

    fill_in     'location[name]', with: location_attributes.name
    attach_file 'location[items_attributes][0][image]', Rails.root.join("spec", "fixtures", "spring-rolls.jpg")
    fill_in     'location[items_attributes][0][price]', with: item_attributes.price
    fill_in     'location[items_attributes][0][description]', with: item_attributes.description
    click_button 'Create'

    validation_message = page.find("#location_items_attributes_0_name").native.attribute("validationMessage")
    expect(validation_message).to eq("Please fill out this field.")
    fill_in     'location[items_attributes][0][name]', with: item_attributes.name
    execute_script <<-JS
      document.getElementById('location_latitude').value = '#{location_attributes.latitude}';
      document.getElementById('location_longitude').value = '#{location_attributes.longitude}';
    JS
    click_button 'Create'

    location = Location.last
    expect(location.latitude).to eq(location_attributes.latitude)
    expect(location.longitude).to eq(location_attributes.longitude)
    expect(location.name).to eq(location_attributes.name)

    item = Item.last
    expect(item.image).to be_attached
    expect(item.name).to  eq(item_attributes.name)
    expect(item.price).to eq(item_attributes.price)
    expect(item.description).to eq(item_attributes.description)

    expect(location.items).to include(item)
  end

  it 'let user post by default location' do
    visit root_path

    click_link 'Post'
    wait_until { page.current_path == new_location_path }

    fill_in     'location[name]', with: location_attributes.name
    attach_file 'location[items_attributes][0][image]', Rails.root.join("spec", "fixtures", "spring-rolls.jpg")
    fill_in     'location[items_attributes][0][price]', with: item_attributes.price
    fill_in     'location[items_attributes][0][description]', with: item_attributes.description
    fill_in     'location[items_attributes][0][name]', with: item_attributes.name

    click_button 'Create'

    location = Location.last
    expect(location.latitude).to eq -6.2189898
    expect(location.longitude).to eq 106.7861758
  end
end

