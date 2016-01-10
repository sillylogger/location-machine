describe "the MVP flow" do

  let!(:user) { FactoryGirl.create :user }

  let(:lat) {  -6.2189898 }
  let(:lng) { 106.7861758 }
  let(:name) { "basement" }

  it "lets users sign in, create an event, and see it" do
    visit new_user_session_path

    fill_in 'user[email]',    with: user.email
    fill_in 'user[password]', with: 'password'
    click_button 'Log in'
    wait_until { page.current_path == root_path }

    click_link 'Post your event!'
    wait_until { page.current_path == new_event_path }

    execute_script <<-JS
      document.getElementById('event_latitude').value = '#{lat}';
      document.getElementById('event_longitude').value = '#{lng}';
    JS
    fill_in 'event[name]',        with: name
    fill_in 'event[description]', with: 'bring a bottle'
    click_button 'Create Event'
    wait_until { page.current_path == root_path }

    event = Event.last
    expect(event.name).to eq(name)
    expect(event.latitude).to eq(lat)
    expect(event.longitude).to eq(lng)
  end

end
