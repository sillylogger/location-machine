require 'rails_helper'

describe "devise/registrations/edit" do

  let(:user) { FactoryBot.create(:user) }

  it "renders the edit registrations form" do
    render template: 'devise/registrations/edit', locals: {
      resource: user
    }

    assert_select "form[action=?][method=?]", user_registration_path, "post" do
      assert_select "input[name*=name][value=?]",   user.name
      assert_select "input[name*=email][value=?]",  user.email
      assert_select "input[name*=phone][value=?]",  user.phone
    end
  end

end
