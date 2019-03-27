RSpec.shared_examples "admin login" do |parameter|
  let(:admin) { FactoryBot.create :facebook_user, :with_admin }

  before :each do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      "provider": "facebook",
      "uid": admin.identities.facebook.first.uid,
      "email": admin.email,
      "name": admin.name
    })

    visit new_user_session_path
    click_link 'Login with Facebook'

    wait_until { page.current_path == admin_dashboard_path }
  end
end

RSpec.shared_examples "user login" do |parameter|
  let(:user) { FactoryBot.create :facebook_user }

  before :each do
    login_as user, scope: :user
  end
end

