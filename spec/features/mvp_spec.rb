describe "the MVP flow" do

  let!(:user) { FactoryBot.create :user }

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
    wait_until { page.current_path == new_party_path }

    execute_script <<-JS
      document.getElementById('party_latitude').value = '#{lat}';
      document.getElementById('party_longitude').value = '#{lng}';
    JS
    fill_in 'party[name]',        with: name
    fill_in 'party[description]', with: 'bring a bottle'
    click_button 'Create Event'
    wait_until { page.current_path == root_path }

    party = Party.last
    expect(party.name).to eq(name)
    expect(party.latitude).to eq(lat)
    expect(party.longitude).to eq(lng)
  end

end
